#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>

#include "config.h"
#include "utils.h"
#include "hash_config.h"

#define PAGE_SIZE 4096

#if defined(__APPLE__) && ARCH==3
#include <pthread.h>
    void bindcore(int core) {
        if (core >= 4) {
            fprintf(stderr, "Bind to P core on macOS\n");
            pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
        } else {
            fprintf(stderr, "Bind to E core on macOS\n");
            pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0);
        }
    }
#elif defined(__linux__)
#include <sched.h>
    void bindcore(int core) {
        cpu_set_t mask;
        CPU_ZERO(&mask);
        CPU_SET(core, &mask);
        sched_setaffinity(0, sizeof(mask), &mask);
    }
#else

#endif

extern uint64_t stld(void* addr1, void* addr2, uint64_t ld_selector);
extern uint64_t stld_evict_blind(void* addr1, void* addr2);

/**
 * @brief Analyze timing data and count BLK cases.
 *
 * @param time   Pointer to the timing array (uint64_t values)
 * @param len    Total length of the timing array
 *
 * @return       Number of values in the second half of the array that exceed
 *               the maximum value of the non-noisy cluster in the first half
 */
int state_analysie(uint64_t* time, int len) {
    int label[len];

    // Perform DBSCAN clustering to filter noisy samples
    int num_of_cluster = dbscan_1d(time, len / 2, cluster_range, len / 4, label);

    // Get maxinum value from non-noisy samples
    int ssb_max = 0;
    for(int i = 0; i < len / 2; ++ i) {
        if (label[i] != -1 && time[i] > ssb_max) {
            ssb_max = time[i];
        }
    }
    // for(int i = 0; i < len / 2; ++ i) {
    //     printf("%ld [%d]", time[i], label[i]);
    // }
    // printf("%d\n", ssb_max);
    int blk_cnt = 0;
    for(int i = len / 2; i < len; ++ i) {
        if (time[i] > ssb_max) {
            blk_cnt += 1;
        }
    }
    // for(int i = 0; i < len; ++ i) {
    //     printf("%ld ", time[i]);
    // }
    // printf("%d %d\n", ssb_max, blk_cnt);
    return blk_cnt;
}

int main(int argc, char* argv[]) {
    // input
    char *ptr = (char*) malloc(40960);
    char *ptr1 = ptr, *ptr2;
    FILE* fin = fopen("in.txt", "r");
    FILE* fout = fopen("out.txt", "w");
    int operation_num, cpu, record_num, base = 16;
    int expected_mdp_val = 0, need_evict = 0; // Learn from state machine analysis
    fscanf(fin, "%d %d %d", &cpu, &operation_num, &expected_mdp_val);
    if (expected_mdp_val == 0) { // state machine is not used
        expected_mdp_val = SIZE_SAMPLE_HSAH;
        need_evict = 1;
    }
    int operation[operation_num], flag[operation_num];
    uint64_t time[SIZE_SAMPLE_HSAH];
    for(int i = 0; i < operation_num; ++ i) {
        fscanf(fin, "%d", &operation[i]);
    }
    fclose(fin);

    char path_buf [0x100] = {};
    sprintf(path_buf, "/proc/%u/pagemap", getpid());

    // bind core
    bindcore(cpu);
    // hot cpu
    char tmp;
    for (int i = 0; i < LOOP_HOT_HASH; i ++){
        ptr2 = ptr + base;
        tmp &= stld(ptr1, ptr2, offset_default);
    }
    // experiments
    void *mem = mmap(NULL, PAGE_SIZE * PAGE_ALLOCATE, PROT_READ | PROT_WRITE, 
        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (mem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    for(int i = 0; i < PAGE_SIZE * PAGE_ALLOCATE - func_len; i += granularity) {
        // printf("%d\n", i);
        if (mprotect(mem, PAGE_SIZE * PAGE_ALLOCATE, PROT_READ | PROT_WRITE) == -1) {
            perror("mprotect");
            return 1;
        }
        int off = i;
        uint8_t *code = (uint8_t *)mem;
        for(int j = 0; j < func_len; ++ j) {
            code[j + off] = ld_jmp[j];
            #if ARCH == 2 || ARCH == 3 || ARCH == 4
            // required on arm CPUs
            asm volatile("dc cvau, %0"::"r"(&code[off + j]));
            asm volatile("ic ivau, %0"::"r"(&code[off + j]));
            asm volatile("dsb ish\nisb");
            #endif
        }
        if (mprotect(mem, PAGE_SIZE * PAGE_ALLOCATE, PROT_READ | PROT_EXEC) == -1) {
            perror("mprotect");
            return 1;
        }
        int collide_cnt = 0;
        for(int try = 0; try < LOOP_TRY_HASH; ++ try) {
            for (int j = 0; j < SIZE_SAMPLE_HSAH / 2; j ++) {
                #if ARCH==31
                ptr2 = ptr + (rand() % 128 + 1) * base;
                *ptr2 = rand() % 4096;
                #else
                ptr2 = ptr + base;
                #endif
                time[j] = stld(ptr1, ptr2, offset_default);
                #if ARCH==0 || ARCH==1
                for(volatile int z = 0; z < 1000; ++ z) {}
                #endif
            }
            
            // timing testing for a single store-load pair
            for (int j = 0; j < operation_num; j ++){
                #if ARCH==31
                ptr2 = ptr + (rand() % 128 + 1) * base * (1 - operation[j]);
                *ptr2 = rand() % 4096;
                #else
                ptr2 = ptr + base * (1 - operation[j]);
                #endif
                stld(ptr1, ptr2, (uint64_t)&code[off] - (uint64_t)stld - offset_first_ins);
                // stld(ptr1, ptr2, offset_default);
                #if ARCH==0 || ARCH==1
                for(volatile int z = 0; z < 1000; ++ z) {}
                #endif
            }
            for (int j = SIZE_SAMPLE_HSAH / 2; j < SIZE_SAMPLE_HSAH; j ++) {
                #if ARCH==31
                ptr2 = ptr + (rand() % 128 + 1) * base;
                *ptr2 = rand() % 4096;
                #else
                ptr2 = ptr + base;
                #endif
                time[j] = stld(ptr1, ptr2, offset_default);
                #if ARCH==0 || ARCH==1
                for(volatile int z = 0; z < 1000; ++ z) {}
                #endif
            }
            if (state_analysie(time, SIZE_SAMPLE_HSAH) >= (expected_mdp_val >= 4 ? expected_mdp_val / 2 : expected_mdp_val)) {
                collide_cnt += 1;
            }
            // evict if necessary
            if (need_evict) {
                for (int j = 0; j < operation_num; j ++){
                    ptr1 = ptr;
                    ptr2 = ptr + base * (1 - operation[j]);
                    stld_evict_blind(ptr1, ptr2);
                }
            }
        }
        // printf("%lx %lx %d\n", &code[off], (uint64_t)stld + 0xac, collide_cnt);
        if (collide_cnt >= COLLIDE_THRESHOLD) {
            uint64_t physical_pg_frame = virt_to_phys(path_buf, (uint64_t)&code[off]);
            fprintf(fout, "%lx %lx ", (uint64_t)&code[off], 
                (physical_pg_frame << 12) | ((uint64_t)&code[off] & 0xfff));
        }
    }
    fprintf(fout, "\n");

    fclose(fout);
    munmap(mem, PAGE_SIZE * PAGE_ALLOCATE);
    return 0;
}
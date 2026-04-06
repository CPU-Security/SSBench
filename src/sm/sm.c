#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>

#include "config.h"

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

extern uint64_t stld(uint64_t* store_addrs, uint64_t* load_addrs, 
    uint64_t* func_addrs, uint64_t func_len, uint64_t* timing);

#define st_jmp_offset_num 64
#if ARCH==0 || ARCH==1
uint64_t st_jmp_offset[st_jmp_offset_num] = {157, 170, 183, 196, 209, 
    222, 235, 248, 261, 274, 287, 300, 313, 326, 339, 352, 365, 378, 
    391, 404, 417, 430, 443, 456, 469, 482, 495, 508, 521, 534, 547, 
    560, 573, 586, 599, 612, 625, 638, 651, 664, 677, 690, 703, 716, 
    729, 742, 755, 768, 781, 794, 807, 820, 830, 840, 850, 860, 870, 
    880, 890, 900, 910, 920, 930, 940};
#define ALIAS_OFFSET 16
#elif ARCH==2 || ARCH==4
uint64_t st_jmp_offset[st_jmp_offset_num] = {164, 172, 180, 188, 196, 
    204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 
    308, 316, 324, 332, 340, 348, 356, 364, 372, 380, 388, 396, 404, 
    412, 420, 428, 436, 444, 452, 460, 468, 476, 484, 492, 500, 508, 
    516, 524, 532, 540, 548, 556, 564, 572, 580, 588, 596, 604, 612, 
    620, 628, 636, 644, 652, 660, 668};
#define ALIAS_OFFSET 16
#elif ARCH==3
uint64_t st_jmp_offset[st_jmp_offset_num] = {164, 172, 180, 188, 196, 
    204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 
    308, 316, 324, 332, 340, 348, 356, 364, 372, 380, 388, 396, 404, 
    412, 420, 428, 436, 444, 452, 460, 468, 476, 484, 492, 500, 508, 
    516, 524, 532, 540, 548, 556, 564, 572, 580, 588, 596, 604, 612, 
    620, 628, 636, 644, 652, 660, 668};
#define ALIAS_OFFSET 64
#else
uint64_t st_jmp_offset[st_jmp_offset_num] = {164, 172, 180, 188, 196, 
    204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 
    308, 316, 324, 332, 340, 348, 356, 364, 372, 380, 388, 396, 404, 
    412, 420, 428, 436, 444, 452, 460, 468, 476, 484, 492, 500, 508, 
    516, 524, 532, 540, 548, 556, 564, 572, 580, 588, 596, 604, 612, 
    620, 628, 636, 644, 652, 660, 668};
#define ALIAS_OFFSET 16
#endif

int main(int argc, char* argv[]) {
    // Input
    char *ptr = (char*) malloc(500);
    char *ptr1, *ptr2;
    FILE* fin = fopen("in.txt", "r");
    FILE* fout = fopen("out.txt", "w");
    int operation_num, cpu, record_num, base = ALIAS_OFFSET;
    fscanf(fin, "%d %d %d", &cpu, &operation_num, &record_num);
    int operation[operation_num], flag[operation_num], 
        operator[operation_num], record_id[record_num];
    uint64_t time[operation_num];
    for(int i = 0; i < operation_num; ++ i) {
        fscanf(fin, "%d", &operation[i]);
    }
    for(int i = 0; i < operation_num; ++ i) {
        fscanf(fin, "%d", &operator[i]);
    }
    for(int i = 0; i < record_num; ++ i) {
        fscanf(fin, "%d", &record_id[i]);
    }
    fclose(fin);

    uint64_t st[operation_num], ld_hot[operation_num], ld[operation_num];
    uint64_t st_jmp_offset_modular[operation_num];
    int t = 0;
    for (int i = 0; i < operation_num; i ++) {
        ptr1 = ptr;
        ptr2 = ptr + base * (1 - operation[i]);
        st[i] = (uint64_t) ptr1;
        ld_hot[i] = (uint64_t) ptr + base;
        ld[i] = (uint64_t) ptr2;
        flag[i] = ptr1 == ptr2;
        st_jmp_offset_modular[i] = st_jmp_offset[operator[i] % st_jmp_offset_num];
    }

    // Bind core
    bindcore(cpu);

    // Hot cpu
    for (int i = 0; i < LOOP_HOT_SM; i ++) {
        stld(&st[i % operation_num], &ld_hot[i % operation_num], 
            &st_jmp_offset_modular[i % operation_num], 
            1, &time[i % operation_num]);
    }

    // Measure the execution time for a single store-load pair
    for (int i = 0; i < operation_num; i ++) {
        stld(&st[i], &ld[i], &st_jmp_offset_modular[i], 1, &time[i]);
        #if ARCH==0 || ARCH==1
        if (st[i] != ld[i])
            for(volatile int z = 0; z < 5000; ++ z) {}
        #endif
    }

    // Output
    for (int i = 0; i < record_num; i ++) {
        fprintf(fout, "%d %ld ", flag[record_id[i]], time[record_id[i]]);
    }
    fprintf(fout, "\n");
    fclose(fout);
    
    return 0;
}
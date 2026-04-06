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

#if ARCH==3
#define ALIAS_OFFSET 64
#else
#define ALIAS_OFFSET 16
#endif

extern uint64_t stld(void* addr1, void* addr2);

int main(int argc, char* argv[]) {
    // Input
    char *ptr = (char*) malloc(500);
    char *ptr1, *ptr2;
    FILE* fin = fopen("in.txt", "r");
    FILE* fout = fopen("out.txt", "w");
    int operation_num, cpu, base = ALIAS_OFFSET;
    fscanf(fin, "%d %d", &cpu, &operation_num);
    int operation[operation_num];
    uint64_t time[operation_num];
    int flag[operation_num];
    for(int i = 0; i < operation_num; ++ i) {
        fscanf(fin, "%d", &operation[i]);
    }
    fclose(fin);

    // Bind core
    bindcore(cpu);

    // Hot cpu
    char tmp;
    for (int i = 0; i < LOOP_HOT_EX; i ++){
        ptr1 = ptr;
        ptr2 = ptr + base;
        tmp &= stld(ptr1, ptr2);
    }
    #if ARCH==31  // Apple
    for (int i = 0; i < 10; i ++){
        tmp &= stld(ptr, ptr);
    }
    for (int i = 0; i < 100; i ++){
        tmp &= stld(ptr, ptr + base);
    }    
    #endif

    // Measure the execution time for a single store-load pair
    for (int i = 0; i < operation_num; i ++){
        ptr1 = ptr;
        ptr2 = ptr + base * (1 - operation[i]);
        time[i] = stld(ptr1, ptr2);
        flag[i] = ptr1 == ptr2;
    }

    // Output
    for (int i = 0; i < operation_num; i ++){
        fprintf(fout, "%d %ld ", flag[i], time[i]);

    }
    fprintf(fout, "\n");
    fclose(fout);
    
    return 0;
}
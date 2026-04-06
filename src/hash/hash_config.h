#include "config.h"

#if ARCH==0 // AMD
/**
 *  movq 0(%rsi), %rax
 *  jmp *%r10
 */
#define PAGE_ALLOCATE (1 << 8)
#define COLLIDE_THRESHOLD (LOOP_TRY_HASH * 0.8)
int granularity = 1;
int func_len = 6;
int offset_default = 165;
int offset_first_ins = 14;
int cluster_range = 50;
uint8_t ld_jmp[6] = {72, 139, 6, 65, 255, 226};
#elif ARCH==1 // Intel
/**
 *  movq 0(%rsi), %rax
 *  jmp *%r10
 */
#define PAGE_ALLOCATE (1 << 8)
#define COLLIDE_THRESHOLD (LOOP_TRY_HASH * 0.8)
int granularity = 1;
int func_len = 6;
int offset_default = 165;
int offset_first_ins = 7;
int cluster_range = 30;
uint8_t ld_jmp[6] = {72, 139, 6, 65, 255, 226};
#elif ARCH==2 // Arm Cortex
/**
 *  ldr     x3, [x1]
 *  br      x7
 */
#define PAGE_ALLOCATE (1 << 10)
#define COLLIDE_THRESHOLD (LOOP_TRY_HASH * 0.1)
int granularity = 4;
int func_len = 8;
int offset_default = 164;
int offset_first_ins = 0;
int cluster_range = 5;
uint8_t ld_jmp[8] = {35, 0, 64, 249, 224, 0, 31, 214};
#elif ARCH==3 // Apple
/**
 *  ldr     x3, [x1]
 *  br      x7
 */
#define PAGE_ALLOCATE (1 << 10)
#define COLLIDE_THRESHOLD (LOOP_TRY_HASH * 0.9)
int granularity = 4;
int func_len = 8;
int offset_default = 164;
int offset_first_ins = 0;
int cluster_range = 5;
uint8_t ld_jmp[8] = {35, 0, 64, 249, 224, 0, 31, 214};
#elif ARCH==4 // Arm Neoverse
/**
 *  ldr     x3, [x1]
 *  br      x7
 */
#define PAGE_ALLOCATE (1 << 10)
#define COLLIDE_THRESHOLD (LOOP_TRY_HASH * 0.8)
int granularity = 4;
int func_len = 8;
int offset_default = 164;
int offset_first_ins = 0;
int cluster_range = 5;
uint8_t ld_jmp[8] = {35, 0, 64, 249, 224, 0, 31, 214};
#endif
#include "config.h"

#define st_jmp_offset_num 2
#define ld_jmp_offset_num 4096
#define eviction_size_max 128
#define ORG_SHARED_FILE_NAME "shared.mem"

#if ARCH==0 || ARCH==1
// movq 0(%r14), %rax
// jmp *%r9
int cluster_range = 80;
#define ld_seg_len 6
#define ORG_MAP_SIZE 64
#define ORG_MAPPING_OFFSET 0
#define ALIAS_OFFSET 16
int ld_set_ins[ld_seg_len] = {73, 139, 6, 65, 255, 225};
uint64_t st_jmp_offset[st_jmp_offset_num] = {31, 175};
#elif ARCH==2
// ldr x7, [x7]  
// br x11
int cluster_range = 5;
#define ld_seg_len 8
#define ORG_MAP_SIZE 64
#define ORG_MAPPING_OFFSET 0
#define ALIAS_OFFSET 16
int ld_set_ins[ld_seg_len] = {231, 0, 64, 249, 96, 1, 31, 214};
uint64_t st_jmp_offset[st_jmp_offset_num] = {168, 184};
#elif ARCH==31
// ldr x7, [x7]  
// br x11
int cluster_range = 50;
#define ld_seg_len 8
#define ORG_MAP_SIZE 16
#define ORG_MAPPING_OFFSET 0x1000000
#define ALIAS_OFFSET 64
int ld_set_ins[ld_seg_len] = {231, 0, 64, 249, 96, 1, 31, 214};
uint64_t st_jmp_offset[st_jmp_offset_num] = {168, 184};
#endif
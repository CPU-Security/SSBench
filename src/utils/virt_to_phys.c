#include "utils.h"
#include <errno.h>
#include <stdio.h>
#include <unistd.h>

#if defined(__linux__)

#define PAGEMAP_ENTRY 8
#define GET_BIT(X,Y) (X & ((uint64_t)1<<Y)) >> Y
#define GET_PFN(X) X & 0x7FFFFFFFFFFFFF

const int __endian_bit = 1;
#define is_bigendian() ( (*(char*)&__endian_bit) == 0 )

uint64_t virt_to_phys(char * path_buf, unsigned long virt_addr) {
    FILE * f;

    f = fopen(path_buf, "rb");
    if(!f){
        printf("Error! Cannot open %s\n", path_buf);
        return -1;
    }
   
    uint64_t file_offset = virt_addr / getpagesize() * PAGEMAP_ENTRY;

    if(fseek(f, file_offset, SEEK_SET) != 0){
        perror("Failed to do fseek!");
        return -1;
    }
    errno = 0;
    uint64_t read_val = 0;
    unsigned char c_buf[PAGEMAP_ENTRY];
    for(int i = 0; i < PAGEMAP_ENTRY; ++ i){
        int c = getc(f);
        if (c == EOF){
            printf("\nReached end of the file\n");
            return 0;
        }
        if (is_bigendian())
            c_buf[i] = c;
        else
            c_buf[PAGEMAP_ENTRY - i - 1] = c;
    }
    for(int i = 0; i < PAGEMAP_ENTRY; ++ i){
        read_val = (read_val << 8) + c_buf[i];
    }
    fclose(f);
    return (unsigned long long) GET_PFN(read_val);
}
#elif defined(__APPLE__)
uint64_t virt_to_phys(char * path_buf, unsigned long virt_addr) {
    return -1;
}
#else
uint64_t virt_to_phys(char * path_buf, unsigned long virt_addr) {
    return -1;
}
#endif
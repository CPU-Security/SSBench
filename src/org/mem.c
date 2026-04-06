#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include "org_config.h"
#include "utils.h"
#include "config.h"

static void die(int fd, const char *msg) {
    if (fd > 0) close(fd);
    perror(msg);
    exit(EXIT_FAILURE);
}

static void usage(int op) {
    fprintf(stderr,
            "Error: unknown op %d\n"
            "  op: 0: create file and map, 1: get map info, 2: unmap file. \n",
            op);
}

static int open_or_create_file(const char *path) {
    int fd;
    struct stat st;
    if (access(path, F_OK) == 0) {
        fd = open(path, O_RDWR);
        if (fd < 0) die(fd, "open(existing)");
        if (fstat(fd, &st) < 0) die(fd, "fstat");
        if (st.st_size < ORG_MAP_SIZE * PAGE_SIZE) {
            size_t len = ORG_MAP_SIZE * PAGE_SIZE;
            if (ftruncate(fd, (off_t)len) < 0) die(fd, "ftruncate(existing->grow)");
        }
    } else {
        // file not exist: create the file and expand it to ORG_MAP_SIZE pages
        fd = open(path, O_RDWR | O_CREAT, 0600);
        if (fd < 0) die(fd, "open(create)");
        size_t len = ORG_MAP_SIZE * PAGE_SIZE;
        if (ftruncate(fd, (off_t)len) < 0) die(fd, "ftruncate(create)");
    }
    return fd;
}

int main(int argc, char **argv) {
    FILE* fin = fopen("in.txt", "r");
    int op;
    uint64_t map_addr;
    fscanf(fin, "%d %ld", &op, &map_addr);
    fclose(fin);

    if (op < 0 || op > 3) {
        usage(op);
        return 0;        
    }

    switch(op) {
        case 0:{
            int fd = open_or_create_file(ORG_SHARED_FILE_NAME);
            void *p = mmap(NULL, ORG_MAP_SIZE * PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
            if (p == MAP_FAILED) {
                die(fd, "mmap");
            }
            memset(p, 0, ORG_MAP_SIZE * PAGE_SIZE);
            
            FILE* fout = fopen("out.txt", "w");
            fprintf(fout, "%lx\n", (uint64_t)p);
            fclose(fout);
            munmap(p, ORG_MAP_SIZE * PAGE_SIZE);
            close(fd);
            break;
        }
        case 1:{
            int fd = open_or_create_file(ORG_SHARED_FILE_NAME);
            void *p = mmap((void*)map_addr + ORG_MAPPING_OFFSET, ORG_MAP_SIZE * PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);
            if (p == MAP_FAILED) {
                die(fd, "mmap");
            }
            int tmp;
            for(int i = 0; i < ORG_MAP_SIZE * PAGE_SIZE; ++ i) {
                tmp &= *(char*)p + i;
            }
            // print address info
            char path_buf [0x100] = {};
            sprintf(path_buf, "/proc/%u/pagemap", getpid());
            FILE* fout = fopen("out.txt", "w");
            fprintf(fout, "%lx\n", (uint64_t)p);
            for(int i = 0; i < ORG_MAP_SIZE * PAGE_SIZE; i += PAGE_SIZE) {
                uint64_t pg_va = (uint64_t)p + i;
                uint64_t physical_pg_frame = virt_to_phys(path_buf, pg_va);
                uint64_t pg_pa = (physical_pg_frame << 12) | (pg_va & 0xfff);
                fprintf(fout, "%lx %lx ", pg_va, pg_pa);
            }
            fprintf(fout, "\n");
            fclose(fout);
            munmap(p, ORG_MAP_SIZE * PAGE_SIZE);
            close(fd);
            break;
        }
        case 2: {
            remove(ORG_SHARED_FILE_NAME);
            break;
        }
        default:
            break;
    }

    return 0;
}

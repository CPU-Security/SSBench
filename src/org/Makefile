CFLAGS = -I.. -D_GNU_SOURCE
os ?= linux
arch ?= amd

ifeq ($(arch), intel)
  arch_file = intel
  arch_id = 1
else ifeq ($(arch), amd)
  arch_file = amd
  arch_id = 0
else ifeq ($(arch), arm)
  arch_file = arm
  arch_id = 2
else ifeq ($(arch), apple)
  arch_file = apple
  arch_id = 3
else ifeq ($(arch), neoverse)
  arch_file = arm
  arch_id = 4
else
  $(error Unknown ARCH: $(arch))
endif

bin	:= ../../bin/org

obj	:= $(bin)/microbenchmark 

obj_mem	:= $(bin)/mem 

all: $(obj) $(obj_mem)

$(obj): org.c  ../utils/cluster.c ../arch/$(arch_file)/org.S ../utils/virt_to_phys.c
	mkdir -p $(bin)
	$(CC) $^ -o $@ $(CFLAGS) -DARCH=$(arch_id)

$(obj_mem): mem.c ../utils/virt_to_phys.c
	$(CC) $^ -o $@ $(CFLAGS) -DARCH=$(arch_id)

clean:
	rm -rf $(obj) $(obj_mem) $(bin)

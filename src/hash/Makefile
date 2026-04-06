CFLAGS = -I.. -D_GNU_SOURCE
os ?= linux
arch ?= amd

ifeq ($(arch), amd)
  arch_file = amd
  arch_id = 0
else ifeq ($(arch), intel)
  arch_file = intel
  arch_id = 1
else ifeq ($(arch), arm)
  arch_file = arm
  arch_id = 2
else ifeq ($(arch), apple)
  arch_file = apple
  arch_id = 31
else ifeq ($(arch), riscv)
  arch_file = riscv
  arch_id = 5
else
  $(error Unknown ARCH: $(arch))
endif

bin	:= ../../bin/hash

obj	:= $(bin)/microbenchmark

all: $(obj)

$(obj): hash.c ../arch/$(arch_file)/hash.S ../utils/cluster.c ../utils/virt_to_phys.c
	mkdir -p $(bin)
	$(CC) $^ -o $@ $(CFLAGS) -DARCH=$(arch_id)

clean:
	rm -rf $(obj) $(bin)

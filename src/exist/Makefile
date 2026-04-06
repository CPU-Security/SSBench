CFLAGS = -I.. -D_GNU_SOURCE
arch ?= intel

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

bin	:= ../../bin/exist

obj	:= $(bin)/microbenchmark

all: $(obj)

$(obj): exist.c ../arch/$(arch_file)/exist.S
	mkdir -p $(bin)
	$(CC) $^ -o $@ $(CFLAGS) -DARCH=$(arch_id)
	objdump -d $@ > $@.s

clean:
	rm -rf $(obj) $(bin)

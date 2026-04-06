from keystone import *
import os
import random

ks = Ks(KS_ARCH_X86, KS_MODE_64)
ks.syntax = KS_OPT_SYNTAX_ATT

asm_code = ["jmp *%r10", "movq 0(%rsi), %rax", "ret"]
print(asm_code)
for c in asm_code:
    machine_code, count = ks.asm(c)
    print(machine_code, count)

asm_code = ["movq (%rsi), %rax", "jmp *%rcx"]
print(asm_code)
for c in asm_code:
    machine_code, count = ks.asm(c)
    print(machine_code, count)

asm_code = ["movq (%rsi), %rdx", "jmp *%r10"]
print(asm_code)
for c in asm_code:
    machine_code, count = ks.asm(c)
    print(machine_code, count)

asm_code = ["movq (%rsi, %rax), %rcx", "jmp *%r12"]
print(asm_code)
for c in asm_code:
    machine_code, count = ks.asm(c)
    print(machine_code, count)

ks = Ks(KS_ARCH_ARM64, KS_MODE_LITTLE_ENDIAN)

asm_code = ["br x4", "ldr x3, [x1]"]
for c in asm_code:
    machine_code, count = ks.asm(c)
    print(machine_code, count)
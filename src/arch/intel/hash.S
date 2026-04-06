.align 4096
.global stld
stld:
    lea (%rip), %r8             // r8 = 0x7
    mov %r8, %r9
    add %rdx, %r9
    mov $171, %r10
    add %r8, %r10
    mfence
    lfence
    rdtscp
    shl $32, %rdx
    or %rax, %rdx
    mov %rdx, %r8
    .rep 30
        imul $1, %rdi
    .endr
    movq $0, 0(%rdi)
    jmp *%r9
ld_default:
    movq 0(%rsi), %rax
    jmp *%r10                       
ldend:                          // offset = 0xac
    .rep 30
        imul $1, %rax
    .endr
    mfence
    rdtscp
    shl $32, %rdx
    or %rax, %rdx
    sub %r8, %rdx
    mov %rdx, %rax
    mfence
    lfence
    ret

.align 4096
.global stld_evict_blind
stld_evict_blind:
    .rep 16
    .rep 30
        imul $1, %rdi
    .endr
    movq $0, 0(%rdi)
    movq 0(%rsi), %rax
    movq 0(%rsi), %rax
    movq 0(%rsi), %rax
    movq 0(%rsi), %rax
    .rep 30
        imul $1, %rax
    .endr
    .endr
    ret
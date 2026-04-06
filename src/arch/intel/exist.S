.align 4096
.global stld
stld:
    lea (%rip), %r8             // offset = 0x7
    mov $162, %r9
    mov $172, %r10
    add %r8, %r9
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
    jmp *%r9
stend:
    movq $0, 0(%rdi)  
    jmp *%r10
ldend:
    movq 0(%rsi), %rax 
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
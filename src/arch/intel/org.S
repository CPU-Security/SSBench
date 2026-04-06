.align 4096
.global stld
stld:
    push %rbx
    push %r12
    push %r13
    push %r14
    push %r15
    push %r9
    mfence
    lfence
    xor %r10, %r10               // r10 = 0
    mov %rdx, %r15
    mov %rcx, %r11
    mov $1, %rcx
stld_start:
    cmp %r10, %r11               // if r10 > r11, goto stld_end
    je stld_end
    mov (%rsi, %r10, 8), %r13 
    mov (%rdi, %r10, 8), %r14
    mov (%r15, %r10, 8), %rdx  
    mov (%rsp), %r9
    mov (%r9, %r10, 8), %r9  
    mov %rdx, %rbx               // rbx = load selector
    lea (%rip), %rdx             // rdx = 0x48   
    add %rdx, %r9                // r9 = 0x48 + r9
    mfence
    lfence
    rdtscp
    shl $32, %rdx
    or %rax, %rdx
    mov %rdx, %r12
    mfence
    lfence
    jmp *%r9                     // pc = 0x64, len = 3

stld_st_0:                       // pc = 0x67
    .rep 30
        imul $1, %r13
    .endr
    movl $0, 0(%r13)
    lea (%rip), %r9              // r9 = 0xee  
    add $150, %r9                // r9 = 0xee + 150
    jmp *%rbx
stld_st_1:                       // pc = 0xf7
    .rep 30
        imul $1, %r13
    .endr
    movl $0, 0(%r13)      
    lea (%rip), %r9              // r9 = 0x17e 
    add $6, %r9                  // r9 = 0x17e + 6
    jmp *%rbx

stld_ld_final:                   // offset = 0x184
    .rep 30
        imul $1, %rax
    .endr
    mfence
    lfence
    rdtscp
    shl    $0x20, %rdx
    or     %rax, %rdx
    sub    %r12, %rdx
    mov    %rdx, (%r8, %r10, 8)
    mfence
    lfence
    inc    %r10
    jmp    stld_start

stld_end:
    pop %r9
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbx
    ret
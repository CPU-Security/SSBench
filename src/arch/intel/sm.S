
.align 4096
.global stld
stld:
    push %r12
    push %r13
    push %r14
    push %r15
    mfence
    lfence
    xor %r10, %r10              // r10 = 0
    mov %rdx, %r15
    mov %rcx, %r11
    mov $1, %rcx
.stld_start:
    cmp %r10, %r11              // if i >= length, end loop
    je .stld_end
    lea (%rip), %r9             // r9 = 0x2e
    mov (%rsi, %r10, 8), %r13   // offset = 0x2e
    mov (%rdi, %r10, 8), %r14
    mov (%r15, %r10, 8), %rdx
    add %rdx, %r9
    mfence
    lfence
    rdtscp
    shl $32, %rdx
    or %rax, %rdx
    mov %rdx, %r12
    .rep 30
        imul $1, %r13
    .endr
    jmp *%r9                    // offset = 154, len = 3

stld_st0:
    movl $0, 0(%r13)            // offset = 157, len = 13
    jmp stld_ld

stld_st1:
    movl $0, 0(%r13)            // offset = 170, len = 13
    jmp stld_ld

stld_st2:
    movl $0, 0(%r13)            // offset = 183, len = 13
    jmp stld_ld

stld_st3:
    movl $0, 0(%r13)            // offset = 196, len = 13
    jmp stld_ld

stld_st4:
    movl $0, 0(%r13)            // offset = 209, len = 13
    jmp stld_ld

stld_st5:
    movl $0, 0(%r13)            // offset = 222, len = 13
    jmp stld_ld

stld_st6:
    movl $0, 0(%r13)            // offset = 235, len = 13
    jmp stld_ld

stld_st7:
    movl $0, 0(%r13)            // offset = 248, len = 13
    jmp stld_ld

stld_st8:
    movl $0, 0(%r13)            // offset = 261, len = 13
    jmp stld_ld

stld_st9:
    movl $0, 0(%r13)            // offset = 274, len = 13
    jmp stld_ld

stld_st10:
    movl $0, 0(%r13)            // offset = 287, len = 13
    jmp stld_ld

stld_st11:
    movl $0, 0(%r13)            // offset = 300, len = 13
    jmp stld_ld

stld_st12:
    movl $0, 0(%r13)            // offset = 313, len = 13
    jmp stld_ld

stld_st13:
    movl $0, 0(%r13)            // offset = 326, len = 13
    jmp stld_ld

stld_st14:
    movl $0, 0(%r13)            // offset = 339, len = 13
    jmp stld_ld

stld_st15:
    movl $0, 0(%r13)            // offset = 352, len = 13
    jmp stld_ld

stld_st16:
    movl $0, 0(%r13)            // offset = 365, len = 13
    jmp stld_ld

stld_st17:
    movl $0, 0(%r13)            // offset = 378, len = 13
    jmp stld_ld

stld_st18:
    movl $0, 0(%r13)            // offset = 391, len = 13
    jmp stld_ld

stld_st19:
    movl $0, 0(%r13)            // offset = 404, len = 13
    jmp stld_ld

stld_st20:
    movl $0, 0(%r13)            // offset = 417, len = 13
    jmp stld_ld

stld_st21:
    movl $0, 0(%r13)            // offset = 430, len = 13
    jmp stld_ld

stld_st22:
    movl $0, 0(%r13)            // offset = 443, len = 13
    jmp stld_ld

stld_st23:
    movl $0, 0(%r13)            // offset = 456, len = 13
    jmp stld_ld

stld_st24:
    movl $0, 0(%r13)            // offset = 469, len = 13
    jmp stld_ld

stld_st25:
    movl $0, 0(%r13)            // offset = 482, len = 13
    jmp stld_ld

stld_st26:
    movl $0, 0(%r13)            // offset = 495, len = 13
    jmp stld_ld

stld_st27:
    movl $0, 0(%r13)            // offset = 508, len = 13
    jmp stld_ld

stld_st28:
    movl $0, 0(%r13)            // offset = 521, len = 13
    jmp stld_ld

stld_st29:
    movl $0, 0(%r13)            // offset = 534, len = 13
    jmp stld_ld

stld_st30:
    movl $0, 0(%r13)            // offset = 547, len = 13
    jmp stld_ld

stld_st31:
    movl $0, 0(%r13)            // offset = 560, len = 13
    jmp stld_ld

stld_st32:
    movl $0, 0(%r13)            // offset = 573, len = 13
    jmp stld_ld

stld_st33:
    movl $0, 0(%r13)            // offset = 586, len = 13
    jmp stld_ld

stld_st34:
    movl $0, 0(%r13)            // offset = 599, len = 13
    jmp stld_ld

stld_st35:
    movl $0, 0(%r13)            // offset = 612, len = 13
    jmp stld_ld

stld_st36:
    movl $0, 0(%r13)            // offset = 625, len = 13
    jmp stld_ld

stld_st37:
    movl $0, 0(%r13)            // offset = 638, len = 13
    jmp stld_ld

stld_st38:
    movl $0, 0(%r13)            // offset = 651, len = 13
    jmp stld_ld

stld_st39:
    movl $0, 0(%r13)            // offset = 664, len = 13
    jmp stld_ld

stld_st40:
    movl $0, 0(%r13)            // offset = 677, len = 13
    jmp stld_ld

stld_st41:
    movl $0, 0(%r13)            // offset = 690, len = 13
    jmp stld_ld

stld_st42:
    movl $0, 0(%r13)            // offset = 703, len = 13
    jmp stld_ld

stld_st43:
    movl $0, 0(%r13)            // offset = 716, len = 13
    jmp stld_ld

stld_st44:
    movl $0, 0(%r13)            // offset = 729, len = 13
    jmp stld_ld

stld_st45:
    movl $0, 0(%r13)            // offset = 742, len = 13
    jmp stld_ld

stld_st46:
    movl $0, 0(%r13)            // offset = 755, len = 13
    jmp stld_ld

stld_st47:
    movl $0, 0(%r13)            // offset = 768, len = 13
    jmp stld_ld

stld_st48:
    movl $0, 0(%r13)            // offset = 781, len = 13
    jmp stld_ld

stld_st49:
    movl $0, 0(%r13)            // offset = 794, len = 13
    jmp stld_ld

stld_st50:
    movl $0, 0(%r13)            // offset = 807, len = 13
    jmp stld_ld

stld_st51:
    movl $0, 0(%r13)            // offset = 817, len = 10
    jmp stld_ld

stld_st52:
    movl $0, 0(%r13)            // offset = 827, len = 10
    jmp stld_ld

stld_st53:
    movl $0, 0(%r13)            // offset = 837, len = 10
    jmp stld_ld

stld_st54:
    movl $0, 0(%r13)            // offset = 847, len = 10
    jmp stld_ld

stld_st55:
    movl $0, 0(%r13)            // offset = 857, len = 10
    jmp stld_ld

stld_st56:
    movl $0, 0(%r13)            // offset = 867, len = 10
    jmp stld_ld

stld_st57:
    movl $0, 0(%r13)            // offset = 877, len = 10
    jmp stld_ld

stld_st58:
    movl $0, 0(%r13)            // offset = 887, len = 10
    jmp stld_ld

stld_st59:
    movl $0, 0(%r13)            // offset = 897, len = 10
    jmp stld_ld

stld_st60:
    movl $0, 0(%r13)            // offset = 907, len = 10
    jmp stld_ld

stld_st61:
    movl $0, 0(%r13)            // offset = 917, len = 10
    jmp stld_ld

stld_st62:
    movl $0, 0(%r13)            // offset = 927, len = 10
    jmp stld_ld

stld_st63:
    movl $0, 0(%r13)            // offset = 937, len = 10
    jmp stld_ld

stld_ld:
    movq 0(%r14), %rax 
    .rep 30
        imul $1, %rax
    .endr
    mfence
    rdtscp
    shl    $0x20, %rdx
    or     %rax, %rdx
    sub    %r12, %rdx
    mov    %rdx, (%r8, %r10, 8)
    mfence
    lfence
    inc    %r10
    jmp .stld_start

.stld_end:
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    ret

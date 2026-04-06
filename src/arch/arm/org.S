
.align 12
.global stld
stld:
    dsb ish
    isb
    mov x9, #0
    mov x10, #0x1
stld_start:
    cmp x3, x9                  // if x9 == x3, goto stld_end 
    b.eq stld_end
    adr x11, .                  // offset = 0x18
    ldr x6, [x0, x9, lsl #3]    // store address        
    ldr x7, [x1, x9, lsl #3]    // load address
    ldr x13, [x2, x9, lsl #3]   // load selector
    ldr x14, [x5, x9, lsl #3]   // store selector
    add x11, x14, x11
    dsb ish
    isb
    mrs x8, pmccntr_el0
    dsb ish
    isb
    .rep 30
        mul x6, x6, x10
    .endr
    br x11                      // offset = 0xbc

stld_st_0:
    str x6, [x6]                // offset = 0xc0
    adr x11, .                  // offset = 0xc4
    add x11, x11, #28
    br x13

stld_st_1:
    str x6, [x6]                // offset = 0xd0
    adr x11, .                  // offset = 0xd4
    add x11, x11, #12
    br x13

stld_ld_final:                  // offset = 0xe0     
    .rep 30
        mul x7, x7, x10
    .endr
    dsb ish
    isb
    mrs x12, pmccntr_el0
    dsb ish
    isb
    sub x12, x12, x8
    str x12, [x4, x9, lsl #3]
    add x9, x9, x10
    b stld_start

stld_end:
    ret

.align 12
.global stld_evict_blind
.rep 10
nop
.endr
stld_evict_blind:
    mov x2, #1
    .rep 16
    .rep 30
        mul x0, x0, x2
    .endr
    str xzr, [x0]
    ldr x3, [x1]
    ldr x3, [x1]
    ldr x3, [x1]
    ldr x3, [x1]
    .rep 30
        mul x3, x3, x2
    .endr
    .endr
    ret
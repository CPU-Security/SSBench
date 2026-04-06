.align 12
.global stld
stld:
    adr x5, .
    add x6, x5, x2
    add x7, x5, #0xac
    mov x2, #1
    dsb ish
    isb
    mrs x4, pmccntr_el0
    dsb ish
    isb
    .rep 30
        mul x0, x0, x2
    .endr
    str xzr, [x0]
    br x6

ld_default:                // offset = 0xa4
    ldr x3, [x1]
    br x7   
ldend:                     // offset = 0xac     
    .rep 30
        mul x3, x3, x2
    .endr
    dsb ish
    isb
    mrs x0, pmccntr_el0
    dsb ish
    isb
    sub x0, x0, x4
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
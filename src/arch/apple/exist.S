.global _stld
_stld:
    adr x5, .
    add x6, x5, #160
    add x7, x5, #168
    mov x2, #1
    dsb ish
    isb
    mrs x4, S3_2_c15_c0_0
    dsb ish
    isb
    .rep 30
        mul x0, x0, x2
    .endr
    br x6
    str xzr, [x0]
    br x7
    ldr x3, [x1]
    .rep 30
        mul x3, x3, x2
    .endr
    dsb ish
    isb
    mrs x0, S3_2_c15_c0_0
    dsb ish
    isb
    sub x0, x0, x4
    ret
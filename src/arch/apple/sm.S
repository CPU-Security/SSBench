
.align 12
.global _stld
_stld:
    dsb ish
    isb
    mov x9, #0
    mov x10, #0x1
_stld_start:
    cmp x3, x9                  // if x9 == x3, goto stld_end 
    b.eq _stld_end
    adr x11, .                  // offset = 0x18
    ldr x5, [x0, x9, lsl #3]            
    ldr x6, [x1, x9, lsl #3] 
    ldr x7, [x2, x9, lsl #3] 
    add x11, x7, x11
    dsb ish
    isb
    mrs x8, S3_2_c15_c0_0
    dsb ish
    isb
    .rep 30
        mul x5, x5, x10
    .endr
    br x11                      // offset = 160, len = 4

_stld_st0:
    str xzr, [x5]               // offset = 164, len = 8
    b _stld_ld

_stld_st1:
    str xzr, [x5]               // offset = 172, len = 8
    b _stld_ld

_stld_st2:
    str xzr, [x5]               // offset = 180, len = 8
    b _stld_ld

_stld_st3:
    str xzr, [x5]               // offset = 188, len = 8
    b _stld_ld

_stld_st4:
    str xzr, [x5]               // offset = 196, len = 8
    b _stld_ld

_stld_st5:
    str xzr, [x5]               // offset = 204, len = 8
    b _stld_ld

_stld_st6:
    str xzr, [x5]               // offset = 212, len = 8
    b _stld_ld

_stld_st7:
    str xzr, [x5]               // offset = 220, len = 8
    b _stld_ld

_stld_st8:
    str xzr, [x5]               // offset = 228, len = 8
    b _stld_ld

_stld_st9:
    str xzr, [x5]               // offset = 236, len = 8
    b _stld_ld

_stld_st10:
    str xzr, [x5]               // offset = 244, len = 8
    b _stld_ld

_stld_st11:
    str xzr, [x5]               // offset = 252, len = 8
    b _stld_ld

_stld_st12:
    str xzr, [x5]               // offset = 260, len = 8
    b _stld_ld

_stld_st13:
    str xzr, [x5]               // offset = 268, len = 8
    b _stld_ld

_stld_st14:
    str xzr, [x5]               // offset = 276, len = 8
    b _stld_ld

_stld_st15:
    str xzr, [x5]               // offset = 284, len = 8
    b _stld_ld

_stld_st16:
    str xzr, [x5]               // offset = 292, len = 8
    b _stld_ld

_stld_st17:
    str xzr, [x5]               // offset = 300, len = 8
    b _stld_ld

_stld_st18:
    str xzr, [x5]               // offset = 308, len = 8
    b _stld_ld

_stld_st19:
    str xzr, [x5]               // offset = 316, len = 8
    b _stld_ld

_stld_st20:
    str xzr, [x5]               // offset = 324, len = 8
    b _stld_ld

_stld_st21:
    str xzr, [x5]               // offset = 332, len = 8
    b _stld_ld

_stld_st22:
    str xzr, [x5]               // offset = 340, len = 8
    b _stld_ld

_stld_st23:
    str xzr, [x5]               // offset = 348, len = 8
    b _stld_ld

_stld_st24:
    str xzr, [x5]               // offset = 356, len = 8
    b _stld_ld

_stld_st25:
    str xzr, [x5]               // offset = 364, len = 8
    b _stld_ld

_stld_st26:
    str xzr, [x5]               // offset = 372, len = 8
    b _stld_ld

_stld_st27:
    str xzr, [x5]               // offset = 380, len = 8
    b _stld_ld

_stld_st28:
    str xzr, [x5]               // offset = 388, len = 8
    b _stld_ld

_stld_st29:
    str xzr, [x5]               // offset = 396, len = 8
    b _stld_ld

_stld_st30:
    str xzr, [x5]               // offset = 404, len = 8
    b _stld_ld

_stld_st31:
    str xzr, [x5]               // offset = 412, len = 8
    b _stld_ld

_stld_st32:
    str xzr, [x5]               // offset = 420, len = 8
    b _stld_ld

_stld_st33:
    str xzr, [x5]               // offset = 428, len = 8
    b _stld_ld

_stld_st34:
    str xzr, [x5]               // offset = 436, len = 8
    b _stld_ld

_stld_st35:
    str xzr, [x5]               // offset = 444, len = 8
    b _stld_ld

_stld_st36:
    str xzr, [x5]               // offset = 452, len = 8
    b _stld_ld

_stld_st37:
    str xzr, [x5]               // offset = 460, len = 8
    b _stld_ld

_stld_st38:
    str xzr, [x5]               // offset = 468, len = 8
    b _stld_ld

_stld_st39:
    str xzr, [x5]               // offset = 476, len = 8
    b _stld_ld

_stld_st40:
    str xzr, [x5]               // offset = 484, len = 8
    b _stld_ld

_stld_st41:
    str xzr, [x5]               // offset = 492, len = 8
    b _stld_ld

_stld_st42:
    str xzr, [x5]               // offset = 500, len = 8
    b _stld_ld

_stld_st43:
    str xzr, [x5]               // offset = 508, len = 8
    b _stld_ld

_stld_st44:
    str xzr, [x5]               // offset = 516, len = 8
    b _stld_ld

_stld_st45:
    str xzr, [x5]               // offset = 524, len = 8
    b _stld_ld

_stld_st46:
    str xzr, [x5]               // offset = 532, len = 8
    b _stld_ld

_stld_st47:
    str xzr, [x5]               // offset = 540, len = 8
    b _stld_ld

_stld_st48:
    str xzr, [x5]               // offset = 548, len = 8
    b _stld_ld

_stld_st49:
    str xzr, [x5]               // offset = 556, len = 8
    b _stld_ld

_stld_st50:
    str xzr, [x5]               // offset = 564, len = 8
    b _stld_ld

_stld_st51:
    str xzr, [x5]               // offset = 572, len = 8
    b _stld_ld

_stld_st52:
    str xzr, [x5]               // offset = 580, len = 8
    b _stld_ld

_stld_st53:
    str xzr, [x5]               // offset = 588, len = 8
    b _stld_ld

_stld_st54:
    str xzr, [x5]               // offset = 596, len = 8
    b _stld_ld

_stld_st55:
    str xzr, [x5]               // offset = 604, len = 8
    b _stld_ld

_stld_st56:
    str xzr, [x5]               // offset = 612, len = 8
    b _stld_ld

_stld_st57:
    str xzr, [x5]               // offset = 620, len = 8
    b _stld_ld

_stld_st58:
    str xzr, [x5]               // offset = 628, len = 8
    b _stld_ld

_stld_st59:
    str xzr, [x5]               // offset = 636, len = 8
    b _stld_ld

_stld_st60:
    str xzr, [x5]               // offset = 644, len = 8
    b _stld_ld

_stld_st61:
    str xzr, [x5]               // offset = 652, len = 8
    b _stld_ld

_stld_st62:
    str xzr, [x5]               // offset = 660, len = 8
    b _stld_ld

_stld_st63:
    str xzr, [x5]               // offset = 668, len = 8
    b _stld_ld

_stld_ld:
    ldr x6, [x6]  
    .rep 30
        mul x6, x6, x10
    .endr
    dsb ish
    isb
    mrs x12, S3_2_c15_c0_0
    dsb ish
    isb
    sub    x12, x12, x8
    str    x12, [x4, x9, lsl #3]
    add    x9, x9, x10
    b _stld_start

_stld_end:
    ret

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

.importzp controller_state
.importzp ball_y
.importzp player_2_y

; ------------------
; Code
; ------------------

.segment "CODE"

.export computer_init
.proc computer_init
    rts
.endproc

.export computer_update
.proc computer_update
    php
    pha
    txa
    pha
    tya
    pha

    lda player_2_y
    clc
    adc #12
    cmp ball_y
    bcc player_2_is_above_ball

    player_2_is_below_ball:
        lda #DPAD_UP
        jmp exit

    player_2_is_above_ball:
        lda #DPAD_DOWN

    exit:
        sta controller_state+1
        pla
        tay
        pla
        tax
        pla
        plp
        rts
.endproc

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

computer_x:     .res 1
computer_x_max: .res 1
computer_y:     .res 1
computer_y_max: .res 1
computer_y_dir: .res 1

.exportzp computer_x, computer_x_max, computer_y, computer_y_max

; ------------------
; Code
; ------------------

.segment "CODE"

.export computer_init
.proc computer_init
    lda #1
    sta computer_y_dir

    lda #SCREEN_X_MAX
    clc
    sbc #16
    sta computer_x

    clc
    adc #16
    sta computer_x_max

    lda #SCREEN_Y_MIN
    sta computer_y

    clc
    adc #32
    sta computer_y_max

    ; --- Tile
    lda #$02
    sta SPRITE_6_TILE ; top-left of paddle
    lda #$03
    sta SPRITE_7_TILE ; top-right of paddle
    lda #$12
    sta SPRITE_8_TILE ; middle-left of paddle
    lda #$13
    sta SPRITE_9_TILE ; middle-right of paddle
    lda #$22
    sta SPRITE_10_TILE ; bottom-left of paddle
    lda #$23
    sta SPRITE_11_TILE ; bottom-right of paddle
    rts
.endproc

.export computer_draw
.proc computer_draw
    ; --- Palette
    lda #$01
    sta SPRITE_6_ATTR
    sta SPRITE_7_ATTR
    sta SPRITE_8_ATTR
    sta SPRITE_9_ATTR
    sta SPRITE_10_ATTR
    sta SPRITE_11_ATTR

    ; --- Location
    left_x:
        lda computer_x
        sta SPRITE_6_X
        sta SPRITE_8_X
        sta SPRITE_10_X

    right_x:
        clc
        adc #8
        sta SPRITE_7_X
        sta SPRITE_9_X
        sta SPRITE_11_X

    top_y:
        lda computer_y
        sta SPRITE_6_Y
        sta SPRITE_7_Y

    middle_y:
        clc
        adc #8
        sta SPRITE_8_Y
        sta SPRITE_9_Y

    bottom_y:
        clc
        adc #8
        sta SPRITE_10_Y
        sta SPRITE_11_Y

    ; -- Exit
    rts
.endproc

.export computer_update
.proc computer_update
    move:
        lda computer_y
        clc
        adc computer_y_dir
        sta computer_y

    exit:
        rts
.endproc

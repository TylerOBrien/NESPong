; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

player_2_x:     .res 1
player_2_x_max: .res 1
player_2_y:     .res 1
player_2_y_max: .res 1
player_2_y_dir: .res 1

.importzp controller_state

.exportzp player_2_x, player_2_x_max, player_2_y, player_2_y_max

; ------------------
; Code
; ------------------

.segment "CODE"

.export player_2_init
.proc player_2_init
    lda #0
    sta player_2_y_dir

    lda #215
    sta player_2_x

    clc
    adc #16
    sta player_2_x_max

    lda #SCREEN_Y_MIN
    sta player_2_y

    clc
    adc #32
    sta player_2_y_max

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

    ; --- Palette
    lda #$01
    sta SPRITE_6_ATTR
    sta SPRITE_7_ATTR
    sta SPRITE_8_ATTR
    sta SPRITE_9_ATTR
    sta SPRITE_10_ATTR
    sta SPRITE_11_ATTR

    rts
.endproc

.export player_2_draw
.proc player_2_draw
    ; --- Location
    left_x:
        lda player_2_x
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
        lda player_2_y
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

.export player_2_update
.proc player_2_update
    check_up:
        lda controller_state+1
        and #DPAD_UP
        beq check_down
        ldx #255
        jmp move

    check_down:
        lda controller_state+1
        and #DPAD_DOWN
        beq exit
        ldx #1

    move:
        stx player_2_y_dir
        lda player_2_y
        clc
        adc player_2_y_dir
        sta player_2_y
        lda player_2_y_max
        clc
        adc player_2_y_dir
        sta player_2_y_max

    exit:
        rts
.endproc

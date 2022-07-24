; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

player_x:     .res 1
player_x_dir: .res 1
player_y:     .res 1
player_y_dir: .res 1

.importzp controller_state
.exportzp player_x, player_y

; ------------------
; Code
; ------------------

.segment "CODE"

.export player_init
.proc player_init
    lda #0
    sta player_x_dir
    sta player_y_dir

    lda #16
    sta player_x
    sta player_y
    rts
.endproc

.export player_draw
.proc player_draw
    ; --- Tile
    lda #$02
    sta SPRITE_0_TILE ; top-left of paddle
    lda #$03
    sta SPRITE_1_TILE ; top-right of paddle
    lda #$12
    sta SPRITE_2_TILE ; middle-left of paddle
    lda #$13
    sta SPRITE_3_TILE ; middle-right of paddle
    lda #$22
    sta SPRITE_4_TILE ; bottom-left of paddle
    lda #$23
    sta SPRITE_5_TILE ; bottom-right of paddle

    ; --- Palette
    lda #$01
    sta SPRITE_0_ATTR
    sta SPRITE_1_ATTR
    sta SPRITE_2_ATTR
    sta SPRITE_3_ATTR
    sta SPRITE_4_ATTR
    sta SPRITE_5_ATTR

    ; --- Location
    left_x:
        lda player_x
        sta SPRITE_0_X
        sta SPRITE_2_X
        sta SPRITE_4_X

    right_x:
        clc
        adc #8
        sta SPRITE_1_X
        sta SPRITE_3_X
        sta SPRITE_5_X

    top_y:
        lda player_y
        sta SPRITE_0_Y
        sta SPRITE_1_Y

    middle_y:
        clc
        adc #8
        sta SPRITE_2_Y
        sta SPRITE_3_Y

    bottom_y:
        clc
        adc #8
        sta SPRITE_4_Y
        sta SPRITE_5_Y

    ; -- Exit
    rts
.endproc

.export player_update
.proc player_update
    check_up:
        lda controller_state
        and #DPAD_UP
        beq check_down
        ldx #$FF
        jmp move

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq exit
        ldx #1

    move:
        stx player_y_dir
        lda player_y
        clc
        adc player_y_dir
        sta player_y

    exit:
        rts
.endproc

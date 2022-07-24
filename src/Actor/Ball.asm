; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

ball_x:     .res 1
ball_x_dir: .res 1
ball_y:     .res 1
ball_y_dir: .res 1

.importzp player_x, player_y

; ------------------
; Code
; ------------------

.segment "CODE"

.export ball_init
.proc ball_init
    ; --- Location
    lda #1
    sta ball_x_dir
    sta ball_y_dir
    lda #16
    sta ball_x
    sta ball_y

    ; --- Tile
    lda #$01
    sta SPRITE_6_TILE

    ; --- Palette
    lda #$01
    sta SPRITE_6_ATTR

    ; --- Exit
    rts
.endproc

.export ball_draw
.proc ball_draw
    ; --- Location
    lda ball_x
    sta SPRITE_6_X
    lda ball_y
    sta SPRITE_6_Y

    ; -- Exit
    rts
.endproc

.export ball_update
.proc ball_update
    lda ball_x_dir
    cmp #$01
    beq check_right

    ; --- Moving Left
    check_left:
        lda ball_x
        cmp #SCREEN_X_MIN
        beq bounce_off_left_wall
        jmp check_y

    ; --- Moving Right
    check_right:
        lda ball_x
        cmp #SCREEN_X_MAX
        beq bounce_off_right_wall
        jmp check_y

    bounce_off_left_wall:
        lda #1
        sta ball_x_dir
        jmp check_y

    bounce_off_right_wall:
        lda #255
        sta ball_x_dir

    ; --- Check Y
    check_y:
        lda ball_y_dir
        cmp #255
        beq check_up

    ; --- Moving Down
    check_down:
        lda ball_y
        cmp #SCREEN_Y_MAX
        beq bounce_off_bottom_wall
        jmp move

    ; --- Moving Up
    check_up:
        lda ball_y
        cmp #SCREEN_Y_MIN
        beq bounce_off_top_wall
        jmp move

    bounce_off_top_wall:
        lda #1
        sta ball_y_dir
        jmp move

    bounce_off_bottom_wall:
        lda #255
        sta ball_y_dir

    move:
        ; --- X Position
        lda ball_x
        clc
        adc ball_x_dir
        sta ball_x
        ; --- Y Position
        lda ball_y
        clc
        adc ball_y_dir
        sta ball_y

    ; -- Exit
    rts
.endproc

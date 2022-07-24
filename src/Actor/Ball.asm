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

;
; ball_init
;
.export ball_init
.proc ball_init
    ; --- Location
    lda #1
    sta ball_x_dir
    sta ball_y_dir
    lda #32
    sta ball_x
    lda #48
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

;
; ball_draw
;
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

;
; ball_handle_left
;
.proc ball_handle_left
    lda ball_x              ; Load x-pos of left-side of ball
    cmp #SCREEN_X_MIN       ; Compare left-side of ball to left-side of screen
    bne exit                ; Ball is not touching left-side of screen so exit

    bounce_off_left_wall:   ; Ball is touching left-side of screen
        lda #1
        sta ball_x_dir      ; Set X direction to 1 which is right

    exit:
        rts
.endproc

;
; ball_handle_right
;
.proc ball_handle_right
    lda ball_x              ; Load x-pos of left-side of ball
    clc
    adc #8                  ; Add 8 pixels to move to right-side of ball
    cmp #SCREEN_X_MAX       ; Compare right-side of ball to right-side of screen
    bne exit                ; Ball is not touching right-side of screen so exit

    bounce_off_right_wall:  ; Ball is touching right-side of screen
        lda #255            ; 255 means -1
        sta ball_x_dir      ; Set X direction to 255 which is left

    exit:
        rts
.endproc

;
; ball_handle_up
;
.proc ball_handle_up
    lda ball_y              ; Load y-pos of top-side of ball
    cmp #SCREEN_Y_MIN       ; Compare top-side of ball to top-side of screen
    bne exit                ; Ball is not touching top-side of screen so exit

    bounce_off_top_wall:    ; Ball is touching top-side of screen
        lda #1
        sta ball_y_dir      ; Set Y direction to 1 which is down

    exit:
        rts
.endproc

;
; ball_handle_down
;
.proc ball_handle_down
    lda ball_y              ; Load y-pos of top-side of ball
    clc
    adc #8                  ; Add 8 pixels to move to bottom-side of ball
    cmp #SCREEN_Y_MAX       ; Compare bottom-side of ball to bottom-side of screen
    bne exit                ; Ball is not touching bottom-side of screen so exit

    bounce_off_bottom_wall: ; Ball is touching bottom-side of screen
        lda #255            ; 255 means -1
        sta ball_y_dir      ; Set X direction to -1 which is up

    exit:
        rts
.endproc

;
; ball_handle_up_left
;
.proc ball_handle_up_left
    jsr ball_handle_left
    jsr ball_handle_up
    rts
.endproc

;
; ball_handle_down_left
;
.proc ball_handle_down_left
    jsr ball_handle_left
    jsr ball_handle_down
    rts
.endproc

;
; ball_handle_up_right
;
.proc ball_handle_up_right
    jsr ball_handle_right
    jsr ball_handle_up
    rts
.endproc

;
; ball_handle_down_right
;
.proc ball_handle_down_right
    jsr ball_handle_right
    jsr ball_handle_down
    rts
.endproc

;
; ball_update
;
.export ball_update
.proc ball_update
    lda ball_x_dir
    cmp #1
    beq moving_right

    moving_left:
        lda ball_y_dir
        cmp #1
        beq moving_down_left
        jsr ball_handle_up_left
        jmp exit

    moving_down_left:
        jsr ball_handle_down_left
        jmp exit

    moving_right:
        lda ball_y_dir
        cmp #1
        beq moving_down_right
        jsr ball_handle_up_right
        jmp exit

    moving_down_right:
        jsr ball_handle_down_right
        jmp exit

    exit:
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
        rts
.endproc

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

ball_is_between_left_paddle:  .res 1
ball_is_between_right_paddle: .res 1

.exportzp ball_x, ball_y

.importzp player_1_x, player_1_xmax, player_1_y, player_1_ymax
.importzp player_2_x, player_2_xmax, player_2_y, player_2_ymax

; ------------------
; Code
; ------------------

.segment "CODE"

;
; ball_init
;
.export ball_init
.proc ball_init
    lda #0
    sta ball_is_between_left_paddle
    sta ball_is_between_right_paddle

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
    sta SPRITE_12_TILE

    ; --- Palette
    lda #$01
    sta SPRITE_12_ATTR

    ; --- Exit
    rts
.endproc

;
; ball_draw
;
.export ball_draw
.proc ball_draw
    php
    pha
    txa
    pha
    tya
    pha

    ; --- Location
    lda ball_x
    sta SPRITE_12_X
    lda ball_y
    sta SPRITE_12_Y

    ; -- Exit
    pla
    tay
    pla
    tax
    pla
    plp
    rts
.endproc

;
; ball_handle_left
;
.proc ball_handle_left
    lda player_1_x              ; Load x-pos of left-side of player
    clc
    adc #16                     ; Add 16 pixels to move to right-side of player
    cmp ball_x                  ; Compare to left-side of ball
    bne check_hit_left_screen   ; Did not hit player's x-axis so check if ball hit the wall

    check_should_bounce_off_left_player: ; Hit left player X-axis
        lda #1
        cmp ball_is_between_left_paddle
        beq bounce_off_left_player
        jmp exit

    check_hit_left_screen:
        lda ball_x          ; Load x-pos of left-side of ball
        cmp #SCREEN_X_MIN   ; Compare left-side of ball to left-side of screen
        bne exit            ; Ball is not touching left-side of screen so exit

    bounce_off_left_player:
    bounce_off_left_wall:   ; Ball is touching left-side of screen
        lda #1
        sta ball_x_dir      ; Set X direction to 1 which is right
        jmp exit

    exit:
        rts
.endproc

;
; ball_handle_right
;
.proc ball_handle_right
    lda ball_x                  ; Load x-pos of left-side of ball
    clc
    adc #8                      ; Add 8 pixels to move to right-side of ball
    cmp player_2_x              ; Compare to left-side of player2
    bne check_hit_right_screen  ; Did not hit player2's x-axis so check if ball hit the wall

    check_should_bounce_off_right_player:   ; Hit right player X-axis
        lda #1
        cmp ball_is_between_right_paddle    ; Check if between right player's top/bottom
        beq bounce_off_right_player
        jmp exit

    check_hit_right_screen:
        lda ball_x          ; Load x-pos of left-side of ball
        clc
        adc #8              ; Add 8 pixels to move to right-side of ball
        cmp #SCREEN_X_MAX   ; Compare right-side of ball to right-side of screen
        bne exit            ; Ball is not touching right-side of screen so exit

    bounce_off_right_player:
    bounce_off_right_wall:   ; Ball is touching left-side of screen
        lda #255
        sta ball_x_dir      ; Set X direction to 1 which is right
        jmp exit

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
; ball_check_between_left_player
;
.proc ball_check_between_left_player
    lda ball_y
    clc
    adc #8
    cmp player_1_y
    bcs bottom_ball_below_top_player ; Is bottom ball below or equal top player

    not_between:
        lda #0
        sta ball_is_between_left_paddle
        rts

    bottom_ball_below_top_player:
        lda player_1_y
        clc
        adc #24
        cmp ball_y
        bcs bottom_player_below_top_ball ; Is bottom player below or equal top ball
        jmp not_between

    bottom_player_below_top_ball:
        lda #1
        sta ball_is_between_left_paddle
        rts
.endproc

;
; ball_check_between_right_player
;
.proc ball_check_between_right_player
    lda ball_y
    clc
    adc #8
    cmp player_2_y
    bcs bottom_ball_below_top_computer ; Is bottom ball below or equal top computer

    not_between:
        lda #0
        sta ball_is_between_right_paddle
        rts

    bottom_ball_below_top_computer:
        lda player_2_y
        clc
        adc #24
        cmp ball_y
        bcs bottom_player_2_below_top_ball ; Is bottom computer below or equal top ball
        jmp not_between

    bottom_player_2_below_top_ball:
        lda #1
        sta ball_is_between_right_paddle
        rts
.endproc

;
; ball_update
;
.export ball_update
.proc ball_update
    jsr ball_check_between_left_player
    jsr ball_check_between_right_player

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
        lda #0
        ; --- Y Position
        lda ball_y
        clc
        adc ball_y_dir
        sta ball_y
        lda #0
        rts
.endproc

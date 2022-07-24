; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import computer_init, computer_update
.import ball_init, ball_draw, ball_update
.import player_1_init, player_1_draw, player_1_update
.import player_2_init, player_2_draw, player_2_update

.export world_init
.proc world_init
    jsr computer_init
    jsr ball_init
    jsr player_1_init
    jsr player_2_init
    rts
.endproc

.export world_update
.proc world_update
    jsr computer_update
    jsr ball_update
    jsr player_1_update
    jsr player_2_update
    rts
.endproc

.export world_draw
.proc world_draw
    jsr ball_draw
    jsr player_1_draw
    jsr player_2_draw
    rts
.endproc

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import ball_init, ball_draw, ball_update
.import computer_init, computer_draw, computer_update
.import player_init, player_draw, player_update

.export world_init
.proc world_init
    jsr ball_init
    jsr computer_init
    jsr player_init
    rts
.endproc

.export world_update
.proc world_update
    jsr ball_update
    jsr computer_update
    jsr player_update
    rts
.endproc

.export world_draw
.proc world_draw
    jsr ball_draw
    jsr computer_draw
    jsr player_draw
    rts
.endproc

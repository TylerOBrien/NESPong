; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import ball_draw, ball_update
.import player_draw, player_update

.export world_update
.proc world_update
    jsr ball_update
    jsr player_update
    rts
.endproc

.export world_draw
.proc world_draw
    jsr ball_draw
    jsr player_draw
    rts
.endproc

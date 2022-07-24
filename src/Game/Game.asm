; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

game_state: .res 1

.exportzp game_state

; ------------------
; Code
; ------------------

.segment "CODE"

.import world_draw, world_update

.export game_update
.proc game_update
    jsr world_update
    jsr world_draw
    rts
.endproc

.export game_init
.proc game_init
    lda #GAME_STATE_TITLE
    sta game_state
    rts
.endproc

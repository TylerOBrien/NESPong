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

.export game_init
.proc game_init
    lda #GAME_STATE_TITLE
    sta game_state
    rts
.endproc

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

game_mode: .res 1

.exportzp game_mode

; ------------------
; Code
; ------------------

.segment "CODE"

.export game_init
.proc game_init
    lda #1
    sta game_mode
    rts
.endproc

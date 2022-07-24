; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

player_1_score: .res 1
player_2_score: .res 1

; ------------------
; Code
; ------------------

.segment "CODE"

.export score_init
.proc score_init
    lda #0
    sta player_1_score
    sta player_2_score
    rts
.endproc

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import game_draw, game_update

.export nmi_handler
.proc nmi_handler
    jsr game_update

    lda #$00
    sta OAM_ADDR
    lda #$02
    sta OAM_DMA
    lda #$00

    jsr game_draw

    sta $2005
	sta $2005

    rti
.endproc

; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import world_draw, world_update

.export nmi_handler
.proc nmi_handler
    lda #$00
    sta OAM_ADDR
    lda #$02
    sta OAM_DMA
    lda #$00

    jsr world_update
    jsr world_draw

    sta $2005
	sta $2005

    rti
.endproc

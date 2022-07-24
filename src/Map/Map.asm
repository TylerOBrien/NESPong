; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.export map_load_play_nametable
.proc map_load_play_nametable
	ldx #$1f ; tile
    ldy #$81 ; nametable offset

	lda PPU_STATUS
	lda #$20
	sta PPU_ADDR
	sty PPU_ADDR
	stx PPU_DATA

	ldx #$08 ; tile
    ldy #$42 ; nametable offset

	lda PPU_STATUS
	lda #$20
	sta PPU_ADDR
	sty PPU_ADDR
	stx PPU_DATA

    rts
.endproc

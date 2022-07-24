; ------------------
; Includes
; ------------------

.include "constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import map_init, map_load_play_nametable
.import controller_update
.import world_init
.import ppu_init, ppu_start, ppu_vblank_wait

.export main
.proc main
    jsr ppu_init
    jsr world_init

    load_palettes:
        lda palettes,X
        sta PPU_DATA
        inx
        cpx #$20
        bne load_palettes

    jsr map_init
    jsr map_load_play_nametable

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA

    jsr ppu_start

    forever:
        jsr controller_update
        jmp forever
.endproc

; ------------------
; Palettes
; ------------------

.segment "RODATA"
palettes:
    .byte $0d, $00, $10, $20
    .byte $0d, $00, $10, $20
    .byte $0d, $00, $10, $20
    .byte $0d, $00, $10, $20

    .byte $0d, $2d, $10, $15
    .byte $0d, $19, $09, $29
    .byte $0d, $19, $09, $29
    .byte $0d, $19, $09, $29

; ------------------
; CHRs
; ------------------

.segment "CHR"
    .incbin "resources/graphics/pong.chr"

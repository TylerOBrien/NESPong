; ------------------
; Includes
; ------------------

.include "constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

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

    jsr ppu_vblank_wait
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
.byte $0f, $12, $23, $27
.byte $0f, $2b, $3c, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29
.byte $0f, $2d, $10, $15
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

; ------------------
; CHRs
; ------------------

.segment "CHR"
.incbin "resources/graphics/pong.chr"

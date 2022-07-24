; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.export ppu_init
.proc ppu_init
    ldx PPU_STATUS
    ldx #$3f
    stx PPU_ADDR
    ldx #$00
    stx PPU_ADDR
    rts
.endproc

.export ppu_start
.proc ppu_start
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    lda #%10010000  ; turn on NMIs, sprites use first pattern table
    sta PPU_CTRL
    lda #%00011110  ; turn on screen
    sta PPU_MASK
    rts
.endproc

.export ppu_vblank_wait
.proc ppu_vblank_wait
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    rts
.endproc

.export ppu_clear_oam
.proc ppu_clear_oam
    ldx #$00
    loop:
        sta $0200,X
        inx
        inx
        inx
        inx
        bne loop
    rts
.endproc

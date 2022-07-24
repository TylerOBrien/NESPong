; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import main
.import ppu_vblank_wait
.import ppu_clear_oam

.export reset_handler
.proc reset_handler
    sei
    cld
    ldx #$00
    stx PPU_CTRL
    stx PPU_MASK

    jsr ppu_vblank_wait
    jsr ppu_clear_oam
    jsr ppu_vblank_wait

    jmp main
.endproc

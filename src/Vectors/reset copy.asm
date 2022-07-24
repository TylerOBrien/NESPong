; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Code
; ------------------

.segment "CODE"

.import main
.import ppu_clear_oam

.export reset_handler
.proc reset_handler
    sei             ; Disable interrupts
    ldx #$00
    stx PPUCTRL     ; Disable NMI and set VRAM increment to 32
    stx PPUMASK     ; Disable rendering
    stx $4010       ; Disable DMC IRQ
    dex             ; Subtracting 1 from $00 gives $FF, which is a quick way to set the stack pointer to $01FF
    txs
    bit PPUSTATUS   ; Acknowledge stray vblank NMI across reset
    bit SNDCHN      ; Acknowledge DMC IRQ
    lda #$40
    sta P2          ; Disable APU Frame IRQ
    lda #$0F
    sta SNDCHN      ; Disable DMC playback, initialize other channels

    vwait1:
        bit PPUSTATUS   ; It takes one full frame for the PPU to become stable.
        bpl vwait1      ; Wait for the first frame's vblank.

    ; We have about 29700 cycles to burn until the second frame's
    ; vblank. Use this time to get most of the rest of the chipset
    ; into a known state.

    ; Most versions of the 6502 support a mode where ADC and SBC work
    ; with binary-coded decimal. Some 6502-based platforms, such as
    ; Atari 2600, use this for scorekeeping. The second-source 6502 in
    ; the NES ignores the mode setting because its decimal circuit is
    ; dummied out to save on patent royalties, and games either use
    ; software BCD routines or convert numbers to decimal every time
    ; they are displayed. But some post-patent famiclones have a
    ; working decimal mode, so turn it off for best compatibility.
    cld

    ; Clear OAM and the zero page here.
    ldx #0
    jsr ppu_clear_oam  ; clear out OAM from X to end and set X to 0
    txa

    clear_zeropage:
        sta $00,x
        inx
        bne clear_zeropage

    vwait2:
        bit PPUSTATUS  ; After the second vblank, we know the PPU has
        bpl vwait2     ; fully stabilized.

        ; There are two ways to wait for vertical blanking: spinning on
        ; bit 7 of PPUSTATUS (as seen above) and waiting for the NMI
        ; handler to run. Before the PPU has stabilized, you want to use
        ; the PPUSTATUS method because NMI might not be reliable. But
        ; afterward, you want to use the NMI method because if you read
        ; PPUSTATUS at the exact moment that the bit turns on, it'll flip
        ; from off to on to off faster than the CPU can see.
        jmp main
.endproc

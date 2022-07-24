; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

border_vert_count:        .res 1
border_vert_remaining:    .res 1

border_side_count:        .res 1
border_side_remaining:    .res 1

border_side_major_offset: .res 1
border_side_minor_offset: .res 1

border_right_major_offset: .res 1
border_right_minor_offset: .res 1

border_top_major_offset: .res 1
border_top_minor_offset: .res 1

border_bottom_major_offset: .res 1
border_bottom_minor_offset: .res 1

; ------------------
; Code
; ------------------

.segment "CODE"

.export map_init
.proc map_init
    lda #29
    sta border_vert_count
    sta border_vert_remaining

    lda #24
    sta border_side_count
    sta border_side_remaining

    lda #$20
    sta border_side_major_offset
    lda #$61
    sta border_side_minor_offset

    lda #$20
    sta border_right_major_offset
    lda #$7e
    sta border_right_minor_offset

    lda #$20
    sta border_top_major_offset
    lda #$42
    sta border_top_minor_offset

    lda #$23
    sta border_bottom_major_offset
    lda #$62
    sta border_bottom_minor_offset

    rts
.endproc

.proc map_load_play_top_border
    lda border_vert_count
    sta border_vert_remaining

	ldx #$2e ; tile

    loop:
        lda PPU_STATUS
        lda border_top_major_offset
        sta PPU_ADDR
        ldy border_top_minor_offset
        sty PPU_ADDR
        stx PPU_DATA

        tya
        clc
        adc #1
        sta border_top_minor_offset

        continue:
            ldy border_vert_remaining
            dey
            cpy #0
            beq exit
            sty border_vert_remaining
            jmp loop

    exit:
        rts
.endproc

.proc map_load_play_bottom_border
    lda border_vert_count
    sta border_vert_remaining

	ldx #$0e ; tile

    loop:
        lda PPU_STATUS
        lda border_bottom_major_offset
        sta PPU_ADDR
        ldy border_bottom_minor_offset
        sty PPU_ADDR
        stx PPU_DATA

        tya
        clc
        adc #1
        sta border_bottom_minor_offset

        continue:
            ldy border_vert_remaining
            dey
            cpy #0
            beq exit
            sty border_vert_remaining
            jmp loop

    exit:
        rts
.endproc

.proc map_load_play_right_border
    lda border_side_count
    sta border_side_remaining

	ldx #$1d ; tile

    loop:
        lda PPU_STATUS
        lda border_right_major_offset
        sta PPU_ADDR
        ldy border_right_minor_offset
        sty PPU_ADDR
        stx PPU_DATA

        tya
        cmp #$fe
        bne increment_minor

        ; Increment major offset
        lda #$1e
        sta border_right_minor_offset

        lda border_right_major_offset
        clc
        adc #$01
        sta border_right_major_offset
        jmp continue

        increment_minor:
            clc
            adc #$20
            sta border_right_minor_offset

        continue:
            ldy border_side_remaining
            dey
            cpy #0
            beq exit
            sty border_side_remaining
            jmp loop

    exit:
        rts
.endproc

.proc map_load_play_left_border
    lda border_side_count
    sta border_side_remaining

	ldx #$1f ; tile

    loop:
        lda PPU_STATUS
        lda border_side_major_offset
        sta PPU_ADDR
        ldy border_side_minor_offset
        sty PPU_ADDR
        stx PPU_DATA

        tya
        cmp #$e1
        bne increment_minor

        ; Increment major offset
        lda #$01
        sta border_side_minor_offset

        lda border_side_major_offset
        clc
        adc #$01
        sta border_side_major_offset
        jmp continue

        increment_minor:
            clc
            adc #$20
            sta border_side_minor_offset

        continue:
            ldy border_side_remaining
            dey
            cpy #0
            beq exit
            sty border_side_remaining
            jmp loop

    exit:
        rts
.endproc

.export map_load_play_nametable
.proc map_load_play_nametable
    jsr map_load_play_top_border
    jsr map_load_play_bottom_border
    jsr map_load_play_left_border
    jsr map_load_play_right_border

    ; -----Top Left Corner

	ldx #$08 ; tile
	lda PPU_STATUS
	lda #$20
	sta PPU_ADDR
	lda #$41
	sta PPU_ADDR
	stx PPU_DATA

    ; -----Bottom Left Corner

	ldx #$18 ; tile
	lda PPU_STATUS
	lda #$23
	sta PPU_ADDR
	lda #$61
	sta PPU_ADDR
	stx PPU_DATA

    ; -----Top Right Corner

	ldx #$09 ; tile
	lda PPU_STATUS
	lda #$20
	sta PPU_ADDR
	lda #$5e
	sta PPU_ADDR
	stx PPU_DATA

    ; -----Bottom Right Corner

	ldx #$19 ; tile
	lda PPU_STATUS
	lda #$23
	sta PPU_ADDR
	lda #$7e
	sta PPU_ADDR
	stx PPU_DATA

    rts
.endproc

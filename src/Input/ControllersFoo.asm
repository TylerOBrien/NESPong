; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Zeropage
; ------------------

.segment "ZEROPAGE"

controller_state:            .res 2
controller_state_previous:   .res 2
controller_state_buffer:     .res 2

controller_state_tmp_first:  .res 2
controller_state_tmp_second: .res 2

.exportzp controller_state

; ------------------
; Code
; ------------------

.segment "CODE"

.proc controller_store_previous
    lda controller_state ; load controller1
    sta controller_state_previous ; store controller1
    lda controller_state+1 ; load controller2
    sta controller_state_previous+1 ; store controller2
    rts
.endproc

.proc controller_store_current
    lda controller_state_tmp_first
    sta controller_state_tmp_second
    lda controller_state_tmp_first+1
    sta controller_state_tmp_second+1
    rts
.endproc

.proc controller_read
    lda #$01
    sta controller_state_buffer+1
    sta ADDR_CONTROLLER_1
    lsr a
    sta ADDR_CONTROLLER_1

    loop:
        ; --

    rts
.endproc

.export controller_update
.proc controller_update
    jsr controller_store_previous
    jsr controller_read
    jsr controller_store_current
    jsr controller_read

    ldx #1

    check_for_glitch:
        lda controller_state_tmp_first,x
        cmp controller_state_tmp_second,x
        bne fix_glitch

    fix_glitch:
        ;

    eor #$FF
    and controller_state,x

    rts
.endproc

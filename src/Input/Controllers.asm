; ------------------
; Includes
; ------------------

.include "../constants.inc"

; ------------------
; Zeropage
; ------------------

.segment "ZEROPAGE"

controller_state:     .res 2
controller_state_new: .res 2

.exportzp controller_state

; ------------------
; Code
; ------------------

.segment "CODE"

.export controller_update
.proc controller_update
    thisRead = 0
    firstRead = 2
    lastFrameKeys = 4

  ; store the current keypress state to detect key-down later
  lda controller_state
  sta lastFrameKeys
  lda controller_state+1
  sta lastFrameKeys+1

  ; Read the joypads twice in case DMC DMA caused a clock glitch.
  jsr read_pads_once
  lda thisRead
  sta firstRead
  lda thisRead+1
  sta firstRead+1
  jsr read_pads_once

  ; For each player, make sure the reads agree, then find newly
  ; pressed keys.
  ldx #1
@fixupKeys:

  ; If the player's keys read out the same way both times, update.
  ; Otherwise, keep the last frame's keypresses.
  lda thisRead,x
  cmp firstRead,x
  bne @dontUpdateGlitch
  sta controller_state,x
@dontUpdateGlitch:

  lda lastFrameKeys,x   ; A = keys that were down last frame
  eor #$FF              ; A = keys that were up last frame
  and controller_state,x        ; A = keys down now and up last frame
  sta controller_state_new,x
  dex
  bpl @fixupKeys
  rts

read_pads_once:

  ; Bits from the controllers are shifted into thisRead and
  ; thisRead+1.  In addition, thisRead+1 serves as the loop counter:
  ; once the $01 gets shifted left eight times, the 1 bit will
  ; end up in carry, terminating the loop.
  lda #$01
  sta thisRead+1
  ; Write 1 then 0 to CONTROLLER_ADDR_1 to send a latch signal, telling the
  ; controllers to copy button states into a shift register
  sta CONTROLLER_ADDR_1
  lsr a
  sta CONTROLLER_ADDR_1
  loop:
    ; On NES and AV Famicom, button presses always show up in D0.
    ; On the original Famicom, presses on the hardwired controllers
    ; show up in D0 and presses on plug-in controllers show up in D1.
    ; D2-D7 consist of data from the Zapper, Power Pad, Vs. System
    ; DIP switches, and bus capacitance; ignore them.
    lda CONTROLLER_ADDR_1       ; read player 1's controller
    and #%00000011 ; ignore D2-D7
    cmp #1         ; CLC if A=0, SEC if A>=1
    rol thisRead   ; put one bit in the register
    lda CONTROLLER_ADDR_2       ; read player 2's controller the same way
    and #$03
    cmp #1
    rol thisRead+1
    bcc loop       ; once $01 has been shifted 8 times, we're done
  rts
.endproc

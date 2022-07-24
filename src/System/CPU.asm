; ------------------
; Code
; ------------------

.segment "CODE"

.export cpu_push_registers
.proc cpu_push_registers
    php
    pha
    txa
    pha
    tya
    pha
    rts
.endproc

.export cpu_pull_registers
.proc cpu_pull_registers
    pla
    tay
    pla
    tax
    pla
    plp
    rts
.endproc

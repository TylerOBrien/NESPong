; ------------------
; Code
; ------------------

.segment "CODE"

.export irq_handler
.proc irq_handler
    rti
.endproc

; =============================================================================
; INPUT HANDLER
; Joystick reading for Atari 7800
; =============================================================================

.proc read_controller
    lda controller
    sta controller_old

    lda SWCHA
    eor #$FF            ; Invert (active high)
    sta controller
    rts
.endproc

.proc wait_button
@wait:
    jsr read_controller
    lda controller
    and #JOY_BUTTON_L | JOY_BUTTON_R
    beq @wait
    rts
.endproc

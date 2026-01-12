; =============================================================================
; GAME LOGIC
; Card game mechanics for Rachel
; =============================================================================

.proc cursor_left
    lda hand_cursor
    beq @done
    dec hand_cursor
@done:
    rts
.endproc

.proc cursor_right
    lda hand_cursor
    cmp hand_count
    bcs @done
    inc hand_cursor
@done:
    rts
.endproc

.proc toggle_select
    ldx hand_cursor
    lda hand_selected,x
    eor #$01
    sta hand_selected,x
    rts
.endproc

.proc count_selected
    lda #0
    tax
@loop:
    cpx hand_count
    bcs @done
    lda hand_selected,x
    beq @next
    clc
    adc #1
@next:
    inx
    bne @loop
@done:
    rts
.endproc

.proc process_game_state
    ; Parse game state from RUBP message
    ; TODO: Implement state parsing
    rts
.endproc

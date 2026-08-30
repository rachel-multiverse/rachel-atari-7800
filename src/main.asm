; =============================================================================
; ATARI 7800 RACHEL CLIENT
; Main entry point
; =============================================================================

.include "equates.asm"

.segment "ZEROPAGE"
game_state:     .res 1
frame_count:    .res 1
controller:     .res 1
controller_old: .res 1
temp1:          .res 1
temp2:          .res 1
ptr1:           .res 2
cursor_x:       .res 1

.segment "BSS"
; RUBP buffers
net_buffer_tx:  .res 64
net_buffer_rx:  .res 64

; Game state
current_turn:   .res 1
my_index:       .res 1
discard_top:    .res 1
current_suit:   .res 1
draw_count:     .res 1
hand_count:     .res 1
hand_cursor:    .res 1
hand_cards:     .res 20
hand_selected:  .res 20
msg_sequence:   .res 1

; Display list
display_list:   .res 256

.segment "CODE"

; -----------------------------------------------------------------------------
; Reset vector - entry point
; -----------------------------------------------------------------------------
.proc reset
    sei
    cld

    ; Initialize MARIA
    jsr maria_init
    jsr display_init
    jsr rubp_init
    jsr net_init

    lda #STATE_TITLE
    sta game_state

main_loop:
    jsr wait_vblank
    inc frame_count

    jsr read_controller

    lda game_state
    cmp #STATE_TITLE
    beq do_title
    cmp #STATE_CONNECT
    beq do_connect
    cmp #STATE_GAME
    beq do_game
    jmp main_loop

do_title:
    jsr handle_title
    jmp main_loop

do_connect:
    jsr do_connect_state
    jmp main_loop

do_game:
    jsr process_game
    jmp main_loop
.endproc

; -----------------------------------------------------------------------------
; Title screen handler
; -----------------------------------------------------------------------------
.proc handle_title
    lda controller
    and #JOY_BUTTON_L
    beq @no_start

    lda #STATE_CONNECT
    sta game_state

@no_start:
    rts
.endproc

; -----------------------------------------------------------------------------
; Connection state handler
; -----------------------------------------------------------------------------
.proc do_connect_state
    jsr net_connect
    bcs @failed

    jsr send_hello
    jsr wait_for_game

    lda #STATE_GAME
    sta game_state
    rts

@failed:
    lda #STATE_TITLE
    sta game_state
    rts
.endproc

; -----------------------------------------------------------------------------
; Main game processing
; -----------------------------------------------------------------------------
.proc process_game
    ; Check for network messages
    jsr net_recv
    bcs @no_message

    jsr rubp_validate
    bcs @no_message

    jsr get_message_type
    cmp #MSG_GAME_STATE
    bne @check_end

    jsr process_game_state
    jsr render_game
    jmp @handle_input

@check_end:
    cmp #MSG_PLAYER_WON
    bne @no_message
    jmp game_over

@no_message:
@handle_input:
    ; Only accept input on our turn
    lda current_turn
    cmp my_index
    bne @done

    lda controller
    and #JOY_LEFT
    beq @not_left
    jsr cursor_left
    jsr render_hand
    jmp @done

@not_left:
    lda controller
    and #JOY_RIGHT
    beq @not_right
    jsr cursor_right
    jsr render_hand
    jmp @done

@not_right:
    lda controller
    and #JOY_BUTTON_L
    beq @not_select
    jsr toggle_select
    jsr render_hand
    jmp @done

@not_select:
    lda controller
    and #JOY_BUTTON_R
    beq @not_play
    jsr count_selected
    beq @done
    lda #$FF
    jsr send_play_card
    jmp @done

@not_play:
    lda controller
    and #JOY_UP
    beq @done
    jsr send_draw

@done:
    rts
.endproc

; -----------------------------------------------------------------------------
; Game over handler
; -----------------------------------------------------------------------------
.proc game_over
    jsr display_game_over
    jsr wait_button
    jsr net_close

    lda #STATE_TITLE
    sta game_state
    rts
.endproc

; -----------------------------------------------------------------------------
; Wait for vertical blank
; -----------------------------------------------------------------------------
.proc wait_vblank
@wait:
    bit MSTAT
    bpl @wait
    rts
.endproc

.include "maria.asm"
.include "input.asm"
.include "game.asm"
.include "rubp.asm"
.include "net/serial.asm"

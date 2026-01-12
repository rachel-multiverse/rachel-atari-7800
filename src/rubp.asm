; =============================================================================
; RUBP PROTOCOL HANDLER
; Rachel Universal Binary Protocol for Atari 7800
; =============================================================================

RUBP_MAGIC_R = 'R'
RUBP_MAGIC_A = 'A'
RUBP_MAGIC_C = 'C'
RUBP_MAGIC_H = 'H'

.proc rubp_init
    lda #0
    sta msg_sequence
    rts
.endproc

.proc rubp_validate
    ; Check magic bytes "RACH"
    lda net_buffer_rx
    cmp #RUBP_MAGIC_R
    bne @invalid
    lda net_buffer_rx+1
    cmp #RUBP_MAGIC_A
    bne @invalid
    lda net_buffer_rx+2
    cmp #RUBP_MAGIC_C
    bne @invalid
    lda net_buffer_rx+3
    cmp #RUBP_MAGIC_H
    bne @invalid

    clc                 ; Valid
    rts

@invalid:
    sec                 ; Invalid
    rts
.endproc

.proc get_message_type
    lda net_buffer_rx+5     ; Message type at offset 5
    rts
.endproc

.proc send_hello
    ; Build HELLO message
    lda #RUBP_MAGIC_R
    sta net_buffer_tx
    lda #RUBP_MAGIC_A
    sta net_buffer_tx+1
    lda #RUBP_MAGIC_C
    sta net_buffer_tx+2
    lda #RUBP_MAGIC_H
    sta net_buffer_tx+3

    lda #$01            ; Version
    sta net_buffer_tx+4
    lda #MSG_HELLO
    sta net_buffer_tx+5

    inc msg_sequence
    lda msg_sequence
    sta net_buffer_tx+6

    ; Platform ID
    lda #PLATFORM_ID_LO
    sta net_buffer_tx+8
    lda #PLATFORM_ID_HI
    sta net_buffer_tx+9

    jsr net_send
    rts
.endproc

.proc send_play_card
    ; TODO: Build and send PLAY_CARD message
    rts
.endproc

.proc send_draw
    ; TODO: Build and send DRAW_CARD message
    rts
.endproc

.proc wait_for_game
    ; Wait for initial game state
@wait:
    jsr net_recv
    bcs @wait
    jsr rubp_validate
    bcs @wait
    jsr get_message_type
    cmp #MSG_GAME_STATE
    bne @wait
    jsr process_game_state
    rts
.endproc

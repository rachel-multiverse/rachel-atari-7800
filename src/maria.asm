; =============================================================================
; MARIA GRAPHICS DRIVER
; Display list management for Atari 7800
; =============================================================================

.proc maria_init
    ; Disable DMA during setup
    lda #$00
    sta CTRL

    ; Set background color (dark green for felt)
    lda #$C4
    sta BACKGRND

    ; Set up palette 0 (card colors)
    lda #$0F        ; White
    sta PALETTE0
    lda #$00        ; Black
    sta PALETTE0+1
    lda #$42        ; Red
    sta PALETTE0+2
    lda #$C4        ; Green
    sta PALETTE0+3

    rts
.endproc

.proc display_init
    ; Initialize display list pointer
    lda #<display_list
    sta DPPL
    lda #>display_list
    sta DPPH

    ; Enable DMA
    lda #$43
    sta CTRL

    rts
.endproc

.proc render_game
    ; Build display list for current game state
    ; TODO: Implement display list building
    rts
.endproc

.proc render_hand
    ; Update hand portion of display list
    ; TODO: Implement hand rendering
    rts
.endproc

.proc display_game_over
    ; Show game over screen
    ; TODO: Implement
    rts
.endproc

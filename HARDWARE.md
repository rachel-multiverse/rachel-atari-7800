# Atari 7800 network hardware contract

Status: **transport not implemented; cartridge coprocessor proposed**.

`src/net/serial.asm` contains TODO stubs. It does not drive real pins and a
successful build is not evidence of network support.

The credible product target is a cartridge containing the Rachel ROM, required
RAM, and a small network coprocessor. The coprocessor would expose a byte-wide
mailbox/FIFO in cartridge space and own WiFi/TCP, keeping variable network
latency away from MARIA DMA and avoiding a made-up controller-port UART.

Before code can target it, the cartridge design must freeze:

- mapper and RAM arrangement;
- a collision-free register window;
- data, status and command register semantics;
- reset, interrupt (if any), FIFO depth and overrun behaviour;
- 5 V bus buffering, 3.3 V translation, power and ESD design;
- firmware behaviour for raw TCP to the canonical port 6502.

Minimum status semantics should include RX available, TX space, connected and
error. The coprocessor must buffer at least two 64-byte frames in each direction.

Validation requires a bus trace, adapter/firmware revision, cold-boot test,
HELLO through GAME_STATE evidence, at least one play/draw, and PLAYER_WON from a
complete game. Until the register map and prototype exist, the public status is
“display prototype”, not “hardware ready”.

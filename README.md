# Rachel - Atari 7800 Client

A Rachel card game client for the Atari 7800 ProSystem.

> **Compatibility status:** display/gameplay prototype only. Networking is an
> explicit stub, so this ROM cannot connect to the current server. No physical
> adapter is claimed. See [HARDWARE.md](HARDWARE.md).

## Platform Details

- **CPU**: 6502C @ 1.79 MHz
- **RAM**: 4KB internal + cartridge RAM
- **Graphics**: MARIA custom chip (sprite-based)
- **Display**: 320x240 or 160x240
- **Controller**: Atari joystick
- **Platform ID**: `0x00D7` (215)

## Building

Requires cc65 suite:

```bash
# Install cc65 (macOS)
brew install cc65

# Build
make
```

Output: `build/rachel.a78` (Atari 7800 ROM format)

Launch it with the matching Emu198x core:

```bash
tools/run-emulator
```

Set `EMU198X_ROOT` if the Emu198x workspace is not at the usual sibling
`Projects/198x/Emu198x/emu198x` path. Extra arguments are passed to the core.

## Controls

- **Joystick Left/Right**: Move cursor
- **Left Button**: Toggle card selection
- **Right Button**: Play selected cards
- **Joystick Up**: Draw card

## Hardware Notes

The Atari 7800 is an interesting hybrid:
- Backward compatible with Atari 2600
- MARIA chip provides superior graphics to 2600's TIA
- Can display up to 100 sprites per scanline
- 160x240 or 320x240 resolution modes
- 25 colors from 256-color palette

The normal controller ports are not being claimed as a serial interface. A
practical network product should be cartridge-side hardware, with its register
map designed alongside the cartridge mapper and additional RAM.

## Architecture

The 7800's MARIA chip is sprite-based, requiring a different approach:
- Display list in RAM defines sprite layout
- Each "object" can be 8-32 pixels wide
- Cards rendered as sprite objects
- DMA halts CPU during graphics rendering

## Memory Budget

```
RAM ($1800-$27FF): 4KB
  - Display list:    ~1KB
  - RUBP buffers:    128 bytes
  - Game state:      ~100 bytes
  - Remaining:       ~2.8KB
```

## Files

- `src/main.asm` - Entry point and game loop
- `src/header.asm` - A78 ROM header
- `src/maria.asm` - MARIA graphics driver
- `src/equates.asm` - Constants and addresses
- `src/display.asm` - Display list management
- `src/input.asm` - Joystick reading
- `src/game.asm` - Game logic and rendering
- `src/rubp.asm` - Protocol implementation
- `src/net/serial.asm` - Serial network driver

## Protocol

Uses RUBP (Rachel Unified Binary Protocol):
- 64-byte fixed-size messages
- "RACH" magic header
- Platform ID: 0x00D7 (Atari 7800)

Full specification: [rachel-multiverse/protocol](https://github.com/rachel-multiverse/protocol) — also rendered at <https://rachel.stevehill.xyz/protocol>.

## License

MIT License

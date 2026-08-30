# Rachel - Atari 7800 Client
# Requires cc65 suite

CA65 = ca65
LD65 = ld65
RM = rm -f

TARGET = build/rachel.a78
CONFIG = rachel.cfg

SOURCES = src/main.asm
OBJECTS = build/main.o

.PHONY: all clean

all: $(TARGET)

build/main.o: src/main.asm src/equates.asm src/maria.asm \
              src/input.asm src/game.asm src/rubp.asm src/net/serial.asm
	@mkdir -p build
	$(CA65) -o $@ $<

$(TARGET): $(OBJECTS) $(CONFIG)
	$(LD65) -C $(CONFIG) -o $@ $(OBJECTS)

clean:
	$(RM) build/*.o build/*.a78

NAME = FooQuest
OUTPUT = dist/$(NAME).nes

CHRS = $(patsubst %,resources/graphics/%,\
pong.chr)

OBJ = $(patsubst %,build/%,\
main.o\
Actor/Ball.o\
Actor/Player.o\
Input/Controllers.o\
System/CPU.o\
System/iNES.o\
System/PPU.o\
Vectors/irq.o\
Vectors/nmi.o\
Vectors/reset.o\
World/World.o)

all: config/nes.cfg $(OBJ)
	ld65 -o $(OUTPUT) -C $^

build/main.o: prepare src/main.asm $(CHRS)
	ca65 -o build/main.o src/main.asm

build/%.o: src/%.asm
	ca65 -o $@ $?

prepare:
	@mkdir -p build/Actor
	@mkdir -p build/Input
	@mkdir -p build/System
	@mkdir -p build/Vectors
	@mkdir -p build/World

clean:
	rm -rf build

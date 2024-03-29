NAME = stars

all: clean bin/$(NAME)

bin/$(NAME): bin/$(NAME).o
	ld -o bin/$(NAME) bin/$(NAME).o

bin/$(NAME).o: src/$(NAME).asm bin/
	nasm -f elf64 -o bin/$(NAME).o src/$(NAME).asm

bin/:
	mkdir bin

.PHONY: clean

clean:
	rm -rf bin

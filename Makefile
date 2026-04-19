# AriOs Build System

# --- 1. Variables ---
# Tools
CC = gcc
LD = ld
ASM = nasm

# Flags
# C Flags: 32-bit, no standard library, no relative addressing
CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -g
# ASM Flags: Force 32-bit ELF format
ASM_FLAGS = -f elf32
# Linker Flags: Use our script, output binary, 32-bit mode
LDFLAGS = -m elf_i386 -T src/linker.ld --oformat binary -nostdlib

# Sources
# Find all .c files in src/kernel
C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c src/cpu/*.c)
# Include headers from src/kernel
HEADERS = $(wildcard src/kernel/*.h src/drivers/*.h src/cpu/*.h)
# Create a list of object files (.o) to build from the .c files
OBJ_FILES = ${C_SOURCES:.c=.o}

# --- 2. Main Targets ---

# Default target: Build the disk image
all: ari_os.img

# Rule to run the OS in QEMU
run: all
	qemu-system-i386 -drive format=raw,file=ari_os.img

# --- 3. Build Rules ---

# The Final Disk Image: Bootloader + Kernel + Padding
ari_os.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > ari_os.img
	# Add padding to ensure no disk read errors
	dd if=/dev/zero bs=1M count=1 >> ari_os.img

# The Kernel Binary: Links the "Entry" object + all C objects
kernel.bin: src/x86_64/boot/kernel_entry.o src/cpu/interrupt.o ${OBJ_FILES}
	$(LD) $(LDFLAGS) -o $@ $^

# Add interrupt.o to the list
interrupt.o: src/cpu/interrupt.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# The Bootloader (Raw Binary)
boot.bin: src/x86_64/boot/boot.asm
	$(ASM) -f bin $< -o $@

# --- 4. Compilation Rules ---

# Compile C files
%.o: %.c ${HEADERS}
	$(CC) $(CFLAGS) -c $< -o $@

# Compile Assembly files (like kernel_entry.asm)
%.o: %.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# --- 5. Cleanup ---
clean:
	rm -f *.bin *.img *.elf *.o
	rm -f src/kernel/*.o src/x86_64/boot/*.o src/cpu/*.o src/drivers/*.o

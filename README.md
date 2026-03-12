# AriOs: 32-bit x86 Operating System Kernel

AriOs is an ongoing bare-metal systems research project aimed at understanding low-level computer architecture, memory segmentation, and hardware-software interfacing on x86 architecture. 

Built entirely from scratch, this project bypasses standard C libraries to establish direct control over the CPU state and physical memory.

## ⚙️ System Architecture & Current Capabilities

* **Boot Sequence:** Custom 16-bit bootloader written in NASM that initializes the system stack, loads the kernel into memory via BIOS interrupts (`int 0x13`), and safely transitions the CPU into 32-bit Protected Mode.
* **Memory Management:** Implements a 32-bit flat memory model by configuring a custom Global Descriptor Table (GDT), bypassing legacy real-mode segmentation to allow the execution of compiled C code.
* **I/O & Hardware Communication:** Utilizes custom inline Assembly (`in`/`out` instructions) to establish direct communication with hardware ports.
* **Display Drivers:** Features a custom VGA text-mode driver interacting directly with physical video memory (`0xB8000`) and the monitor's control registers (`0x3D4`/`0x3D5`) to render standard output.
* **Interrupt Foundation:** Establishes the Interrupt Descriptor Table (IDT) and foundational Assembly stubs for Interrupt Service Routines (ISRs) to handle CPU exceptions and future hardware IRQs.

## 🛠️ Tech Stack & Build Infrastructure

* **Languages:** C, x86 Assembly (NASM)
* **Build Tools:** GNU Make, GCC (Cross-Compiler), LD (Custom Linker Scripts)
* **Emulation:** QEMU (`qemu-system-i386`)

## 🗺️ Engineering Roadmap

- [x] Bootloader & Protected Mode Transition
- [x] Global Descriptor Table (GDT) Configuration
- [x] Basic VGA Video Drivers & Port I/O
- [x] Interrupt Descriptor Table (IDT) Layout & ISR Stubs
- [ ] 8259 Programmable Interrupt Controller (PIC) Remapping
- [ ] Hardware Interrupts (IRQs) & PS/2 Keyboard Driver implementation
- [ ] Dynamic Memory Allocation / Paging

## 🚀 Build and Run Instructions

To compile and emulate AriOs locally, you will need `gcc`, `nasm`, and `qemu` installed on your Linux environment.

**1. Clone the repository:**
```bash
git clone https://github.com/DevilUnderTheHood/AriOs.git
cd AriOs
```

**2. Build the OS image (`ari_os.img`):**
```bash
make all
```

**3. Run the OS in QEMU:**
```bash
make run
```

**4. Clean the build directory:**
```bash
make clean
```

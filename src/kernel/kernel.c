#include "../drivers/screen.h"
#include "../cpu/idt.h"
#include "../cpu/isr.h"

void kernel_main() {
    clear_screen();
    print_at("Installing IDT...\n", -1, -1);
    
    // 1. Initialize the IDT
    set_idt();
    
    // 2. Enable Interrupts (sti)
    // This lets the CPU start accepting Timer and Keyboard signals
    __asm__ __volatile__("sti");

    print_at("IDT Loaded. Interrupts Enabled.\n", -1, -1);
    print_at("Press any key to test...\n", -1, -1);
}

#include "isr.h"
#include "idt.h"
#include "../drivers/screen.h"
#include "../drivers/ports.h"
#include "../drivers/keyboard.h"

/* To print exception messages */
char *exception_messages[] = {
    "Division By Zero", "Debug", "Non Maskable Interrupt", "Breakpoint",
    "Into Detected Overflow", "Out of Bounds", "Invalid Opcode", "No Coprocessor",
    "Double Fault", "Coprocessor Segment Overrun", "Bad TSS", "Segment Not Present",
    "Stack Fault", "General Protection Fault", "Page Fault", "Unknown Interrupt",
    "Coprocessor Fault", "Alignment Check", "Machine Check", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved"
};

void isr_handler(registers_t *r) {
    print_at("Received interrupt: ", -1, -1);
    
    char s[3];
    s[0] = r->int_no / 10 + '0';
    s[1] = r->int_no % 10 + '0';
    s[2] = '\0';
    print_at(s, -1, -1);
    print_at("\n", -1, -1);
    
    if (r->int_no < 32) {
        print_at(exception_messages[r->int_no], -1, -1);
        print_at("\nSystem Halted!\n", -1, -1);
        for(;;); // Halt loop
    }
}

void irq_handler(registers_t *r) {
    // Send an EOI (End of Interrupt) signal to the PICs.
    if (r->int_no >= 40) {
        port_byte_out(0xA0, 0x20); 
    }
    port_byte_out(0x20, 0x20);

    if (r->int_no == 32) {
        // TIMER
        // print_at("Tick ", -1, -1); 
    }
    
    if (r->int_no == 33) {
        // KEYBOARD (IRQ 1)
        // 1. Read from the keyboard's data buffer (Port 0x60)
        // This is MANDATORY to acknowledge the keypress.
        unsigned char scancode = port_byte_in(0x60);
        
        // 2. Handle the key presses
        handle_keyboard(scancode);
    }
}

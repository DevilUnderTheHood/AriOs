#include "idt.h"

// The actual IDT array (256 entries)
idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

void set_idt_gate(int n, u32 handler) {
    idt[n].low_offset = handler & 0xFFFF;
    idt[n].sel = KERNEL_CS;
    idt[n].always0 = 0;
    idt[n].flags = 0x8E; // 1(Present) 00(Ring0) 0(Gate) 1110(32-bit Interrupt)
    idt[n].high_offset = (handler >> 16) & 0xFFFF;
}

void set_idt() {
    idt_reg.base = (u32) &idt;
    idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;

    // Load the IDT pointer into the CPU
    // "memory" clobber tells compiler we touched memory
    __asm__ __volatile__("lidt (%0)" : : "r" (&idt_reg));

    // Install the ISRs
    set_idt_gate(0, (u32)isr0);
    set_idt_gate(1, (u32)isr1);
    
    // ...
    set_idt_gate(32, (u32)isr32);
    set_idt_gate(33, (u32)isr33);

}

#include "idt.h"
#include "../drivers/ports.h"

extern void isr0();
extern void isr1();
extern void irq0();
extern void irq1();

idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

void set_idt_gate(int n, u32 handler) {
    idt[n].low_offset = handler & 0xFFFF;
    idt[n].sel = KERNEL_CS;
    idt[n].always0 = 0;
    idt[n].flags = 0x8E; 
    idt[n].high_offset = (handler >> 16) & 0xFFFF;
}

void set_idt() {
    idt_reg.base = (u32) &idt;
    idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;

    // --- THE MISSING PIC REMAP ---
    port_byte_out(0x20, 0x11); // Start initialization
    port_byte_out(0xA0, 0x11);
    port_byte_out(0x21, 0x20); // Master PIC offset (Interrupt 32)
    port_byte_out(0xA1, 0x28); // Slave PIC offset (Interrupt 40)
    port_byte_out(0x21, 0x04); // Tell Master about Slave
    port_byte_out(0xA1, 0x02); // Tell Slave its cascade identity
    port_byte_out(0x21, 0x01); // 8086/88 (x86) mode
    port_byte_out(0xA1, 0x01);
    port_byte_out(0x21, 0x0);  // Unmask all
    port_byte_out(0xA1, 0x0);
    // -----------------------------

    set_idt_gate(0, (u32)isr0);
    set_idt_gate(1, (u32)isr1);
    set_idt_gate(32, (u32)irq0); 
    set_idt_gate(33, (u32)irq1); 

    __asm__ __volatile__("lidt (%0)" : : "r" (&idt_reg));
}

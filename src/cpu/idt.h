#ifndef IDT_H
#define IDT_H

#include "../kernel/type.h"

#define KERNEL_CS 0x08

// IDT Entry(gate) Sturcture

typedef struct {
  u16 low_offset;
  u16 sel;
  u8 always0;
  u8 flags;
  u16 high_offset;
} __attribute__((packed)) idt_gate_t;

// IDT Register (Pointer) structure

typedef struct {
  u16 limit;
  u32 base;
} __attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256

void set_idt_gate(int n, u32 handler);
void set_idt();

extern void isr0();
extern void isr1();
extern void isr32();
extern void isr33();

#endif

#ifndef ISR_H
#define ISR_H

#include "../kernel/type.h"

// This structure MUST match the layout of data pushed by 'interrupt.asm'
// 1. We pushed DS
// 2. We pushed registers (EDI, ESI, EBP, ESP, EBX, EDX, ECX, EAX) via 'pusha'
// 3. We pushed 'int_no' and 'err_code' manually
// 4. The CPU pushed EIP, CS, EFLAGS, UserESP, SS automatically
typedef struct {
   u32 ds;                                     
   u32 edi, esi, ebp, esp, ebx, edx, ecx, eax; 
   u32 int_no, err_code;                       
   u32 eip, cs, eflags, useresp, ss;           
} registers_t;

void isr_handler(registers_t *r);
void irq_handler(registers_t *r);

#endif

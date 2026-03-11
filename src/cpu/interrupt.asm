[bits 32]

[extern isr_handler] ; This will be our C function in isr.c

; Common ISR code
isr_common_stub:
    pusha           ; 1. Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax

    mov ax, ds      ; 2. Save the Data Segment descriptor
    push eax

    mov ax, 0x10    ; 3. Load the Kernel Data Segment descriptor
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call isr_handler ; 4. Call C code

    pop eax         ; 5. Restore the original Data Segment descriptor
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    popa            ; 6. Pop edi,esi,ebp...
    add esp, 8      ; 7. Cleans up the pushed error code and ISR number
    iret            ; 8. Pops 5 things at once: CS, EIP, EFLAGS, SS, ESP

; --- ISR Definitions ---
; The CPU calls these directly. We push the interrupt number and jump to common code.

global isr0
isr0:
    push byte 0     ; Push dummy error code
    push byte 0     ; Push Interrupt Number (0 = Divide by Zero)
    jmp isr_common_stub

global isr1
isr1:
    push byte 0
    push byte 1
    jmp isr_common_stub

; ... We usually define 0-31 (Exceptions) ...
; Let's just do a few common ones for now to save typing

global isr32
isr32:              ; This will be the Timer (IRQ0)
    push byte 0
    push byte 32
    jmp isr_common_stub

global isr33
isr33:              ; This will be the Keyboard (IRQ1)
    push byte 0
    push byte 33
    jmp isr_common_stub

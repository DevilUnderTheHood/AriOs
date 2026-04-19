[bits 32]

; Tell the assembler these functions exist in our C code
[extern isr_handler]
[extern irq_handler]

; -----------------------------------------------------------------------------
; MACROS FOR AUTOMATIC GENERATION
; -----------------------------------------------------------------------------

; Macro for CPU Exceptions that DO NOT push an error code automatically
%macro ISR_NOERRCODE 1
  global isr%1
  isr%1:
    push byte 0    ; Push a dummy error code to keep the stack uniform
    push byte %1   ; Push the interrupt number
    jmp isr_common_stub
%endmacro

; Macro for CPU Exceptions that DO push an error code automatically (like Page Fault)
%macro ISR_ERRCODE 1
  global isr%1
  isr%1:
    ; (The CPU already pushed the error code)
    push byte %1   ; Push the interrupt number
    jmp isr_common_stub
%endmacro

; Macro for Hardware Interrupts (IRQs)
%macro IRQ 2
  global irq%1
  irq%1:
    push byte 0    ; Push dummy error code
    push byte %2   ; Push the remapped interrupt number (e.g., 32 for Timer)
    jmp irq_common_stub
%endmacro

; -----------------------------------------------------------------------------
; DEFINING THE INTERRUPT GATES
; -----------------------------------------------------------------------------

; 0 to 31: CPU Exceptions (Crashes)
ISR_NOERRCODE 0  ; Divide by Zero
ISR_NOERRCODE 1  ; Debug
ISR_NOERRCODE 2  ; NMI
ISR_NOERRCODE 3  ; Breakpoint
ISR_NOERRCODE 4  ; Overflow
ISR_NOERRCODE 5  ; Bounds
ISR_NOERRCODE 6  ; Invalid Opcode
ISR_NOERRCODE 7  ; Device Not Available
ISR_ERRCODE   8  ; Double Fault
ISR_NOERRCODE 9  ; Coprocessor Segment Overrun
ISR_ERRCODE   10 ; Invalid TSS
ISR_ERRCODE   11 ; Segment Not Present
ISR_ERRCODE   12 ; Stack-Segment Fault
ISR_ERRCODE   13 ; General Protection Fault
ISR_ERRCODE   14 ; Page Fault
ISR_NOERRCODE 15 ; Reserved
ISR_NOERRCODE 16 ; x87 Float Exception
ISR_ERRCODE   17 ; Alignment Check
ISR_NOERRCODE 18 ; Machine Check
ISR_NOERRCODE 19 ; SIMD Float Exception
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31

; 32 to 47: Hardware Interrupts (IRQs)
IRQ   0, 32 ; IRQ0 -> Int 32 (Timer)
IRQ   1, 33 ; IRQ1 -> Int 33 (Keyboard)
IRQ   2, 34
IRQ   3, 35
IRQ   4, 36
IRQ   5, 37
IRQ   6, 38
IRQ   7, 39
IRQ   8, 40
IRQ   9, 41
IRQ  10, 42
IRQ  11, 43
IRQ  12, 44
IRQ  13, 45
IRQ  14, 46
IRQ  15, 47

; -----------------------------------------------------------------------------
; THE COMMON STUBS
; -----------------------------------------------------------------------------

; Stub for CPU Crashes
isr_common_stub:
    pusha           ; Save all general purpose registers
    
    mov ax, ds      ; Save original data segment
    push eax
    
    mov ax, 0x10    ; Load Kernel Data Segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp        ; Pass pointer to stack to C function (registers_t *r)
    call isr_handler
    add esp, 4      ; Clean up the pushed pointer

    pop eax         ; Restore original data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    popa            ; Restore all general purpose registers
    add esp, 8      ; Clean up pushed error code and ISR number
    iret            ; Interrupt return

; Stub for Hardware Signals
irq_common_stub:
    pusha           ; Save all general purpose registers
    
    mov ax, ds      ; Save original data segment
    push eax
    
    mov ax, 0x10    ; Load Kernel Data Segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp        ; Pass pointer to stack to C function (registers_t *r)
    call irq_handler
    add esp, 4      ; Clean up the pushed pointer

    pop eax         ; Restore original data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    popa            ; Restore all general purpose registers
    add esp, 8      ; Clean up pushed error code and ISR number
    iret            ; Interrupt return

[bits 16]
switch_to_pm:
    cli                     ; 1. Disable interrupts
    lgdt [gdt_descriptor]   ; 2. Load the GDT descriptor

    mov eax, cr0
    or eax, 0x1             ; 3. Set 32-bit mode bit in CR0
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; 4. Far jump by using a different segment

[bits 32]
; We are now in 32-bit Protected Mode!
init_pm:
    ; 5. Update the segment registers
    ; Now that we are in PM, our old segments are garbage.
    ; We must point them to our DATA_SEG defined in the GDT.
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; 6. Update the stack position
    mov ebp, 0x90000        ; Update the stack right at the top of the free space
    mov esp, ebp

    jmp 0x1000

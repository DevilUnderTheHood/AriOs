[org 0x7c00]
    mov [BOOT_DRIVE], dl
    
    ; 1. Setup Stack
    mov bp, 0x9000
    mov sp, bp

    mov bx,MSG_REAL_MODE
    call print_string

    ; 2. Load Kernel from Disk
    call load_kernel

    ; 3. Switch to Protected Mode
    mov bx,MSG_PROT_MODE
    call print_string
    call switch_to_pm 
    
    jmp $ ; infinite loop (should never reach here)

; Include our helper files
%include "src/x86_64/boot/print_string.asm"
%include "src/x86_64/boot/gdt.asm"
%include "src/x86_64/boot/switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

    mov bx, 0x1000 ; Load to 0x1000
    mov ah, 0x02   ; BIOS read sector
    mov al, 15     ; Read 15 sectors (plenty of space for our kernel)
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov dl, [BOOT_DRIVE] 
    int 0x13
    jc disk_error
    ret

disk_error:
    mov bx, MSG_ERROR
    call print_string
    jmp $

BOOT_DRIVE: db 0
MSG_REAL_MODE: db "[i] Started in 16-bit Real Mode", 0
MSG_PROT_MODE: db "[i] Switching to 32-bit Protected Mode", 0
MSG_LOAD_KERNEL: db "[i] Loading Kernel from disk...", 0
MSG_ERROR: db "[-] Disk Read Error!", 0

; Boot Sector Padding
times 510-($-$$) db 0
dw 0xaa55

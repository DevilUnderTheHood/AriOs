print_string:
    pusha           ; 1. Save all registers so we don't mess up the main code logic

print_loop:
    mov al, [bx]    ; 2. Dereference BX: Get the char at the address BX points to
    cmp al, 0       ; 3. Check for null terminator (end of string)
    je print_done   ;    If zero, jump to end

    mov ah, 0x0e    ; 4. Prepare for BIOS interrupt
    int 0x10        ;    Print the character in AL

    inc bx          ; 5. Move to the next character in memory
    jmp print_loop  ; 6. Loop back to top

print_done:
    mov ah, 0x0e
    
    mov al, 0x0d    ; Carriage Return (Move cursor to left)
    int 0x10
    
    mov al, 0x0a    ; Line Feed (Move cursor down)
    int 0x10
    popa            ; 7. Restore registers
    ret

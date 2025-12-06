; GDT (Global Descriptor Table)
gdt_start:

gdt_null: ; 1. The Mandatory Null Descriptor (8 bytes of zeros)
    dd 0x0
    dd 0x0

gdt_code: ; 2. The Code Segment Descriptor
    ; Base=0x0, Limit=0xfffff,
    ; 1st Flags: (Present)1 (Privilege)00 (Descriptor Type)1 -> 1001b
    ; Type Flags: (Code)1 (Conforming)0 (Readable)1 (Accessed)0 -> 1010b
    ; 2nd Flags: (Granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
    dw 0xffff    ; Limit (bits 0-15)
    dw 0x0       ; Base (bits 0-15)
    db 0x0       ; Base (bits 16-23)
    db 10011010b ; 1st flags, Type flags
    db 11001111b ; 2nd flags, Limit (bits 16-19)
    db 0x0       ; Base (bits 24-31)

gdt_data: ; 3. The Data Segment Descriptor
    ; Same as code segment except for the Type flags:
    ; Type Flags: (Code)0 (Expand Down)0 (Writable)1 (Accessed)0 -> 0010b
    dw 0xffff    ; Limit (bits 0-15)
    dw 0x0       ; Base (bits 0-15)
    db 0x0       ; Base (bits 16-23)
    db 10010010b ; 1st flags, Type flags
    db 11001111b ; 2nd flags, Limit (bits 16-19)
    db 0x0       ; Base (bits 24-31)

gdt_end:

; GDT Descriptor
; This is the tiny structure we actually feed to the CPU telling it 
; "The GDT is located at [gdt_start] and is [size] bytes long"
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size (Limit)
    dd gdt_start               ; Start Address

; Define some constants for the offsets (used later in code)
; 0x00 is null, 0x08 is code, 0x10 is data
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

ENTRY(_start)

SECTIONS
{
    /* We want the binary to start at 1MB (0x1000 is okay too, but lets be explicit) */
    /* Let's stick to 0x1000 to match your bootloader logic */
    . = 0x1000;

    /* 1. The Code Section */
    .text : ALIGN(4K)
    {
        *(.text)
    }

    /* 2. Read-Only Data (strings, constants) */
    .rodata : ALIGN(4K)
    {
        *(.rodata)
    }

    /* 3. Initialized Data (global variables) */
    .data : ALIGN(4K)
    {
        *(.data)
    }

    /* 4. Uninitialized Data (variables you didn't give a value to) */
    .bss : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}

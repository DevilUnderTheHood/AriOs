#include "keyboard.h"
#include "screen.h"

// The Scancode to ASCII lookup table (US QWERTY)
const char scancode_to_ascii[] = {
    '?', '?', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b', '?',
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', '?', 'a', 's',
    'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', '?', '\\', 'z', 'x', 'c', 'v',
    'b', 'n', 'm', ',', '.', '/', '?', '?', '?', ' '
};

void handle_keyboard(unsigned char scancode) {
    // 1. Only process "Key Down" events (Make codes)
    if (scancode < 0x80) {
        
        // 2. Ensure the scancode is within our array bounds (0 to 57)
        if (scancode <= 57) {
            // Translate the scancode to ASCII
            char ascii = scancode_to_ascii[scancode];
            
            // We need a string to pass to print_at (a char followed by a null terminator)
            char str[2] = {ascii, '\0'};
            
            // Print it to the screen!
            print_at(str, -1, -1);
        }
    }
}

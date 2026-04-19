#include "ports.h"

#define VIDEO_MEMORY_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// White on black color scheme
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5


int get_cursor_offset(){
  // The monitor uses its control register to get the index to its internal registers we want to view
  // The register 14 has the higher byte for the cursor position/offset
  // The register 15 has the lower byte for the cursor position/offset

  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;  // Higher byte
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);  // Lower byte

  return offset*2;

}

void set_cursor_offset(int offset){
  offset /= 2;

  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset>>8));

  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

// Printing a character at a specific row and column
void print_char(char character, int col, int row, char attribute_byte){
  unsigned char *vidmem = (unsigned char *) VIDEO_MEMORY_ADDRESS;

  if (!attribute_byte) attribute_byte = WHITE_ON_BLACK;

  int offset;

  if (col >= 0 && row >= 0) offset = (row * MAX_COLS + col) * 2;
  else offset = get_cursor_offset();  // Else get the cursor position from the device itself

  if (character == '\n') {
    int rows = offset / (2 * MAX_COLS);
    offset = (rows + 1) * (2 * MAX_COLS);
    set_cursor_offset(offset);
  }
  else if (character == '\b') {
    // Only backspace if we are not at the very beginning of the screen
    if (offset >= 2) {
      offset -= 2;                  // 1. Move back one character
      vidmem[offset] = ' ';         // 2. Overwrite with a blank space
      vidmem[offset + 1] = attribute_byte;
      set_cursor_offset(offset);    // 3. Update the hardware cursor
    }
  }
  else {
    vidmem[offset] = character;
    vidmem[offset + 1] = attribute_byte;
    set_cursor_offset(offset+2);
  }

                   
}

// For printing a string at a specific row and column
void print_at(char *message, int col, int row){
  if (col >= 0 && row >= 0) {
      // If specific coordinates, set cursor there first
      set_cursor_offset((row * MAX_COLS + col) * 2);
  }
  int i = 0;
  while (message[i] != 0) {
    print_char(message[i], -1, -1, WHITE_ON_BLACK);
    i++;
  }
}


void clear_screen(){
  int screen_size = MAX_COLS * MAX_ROWS;
  int i;
  unsigned char *vidmem = (unsigned char *) VIDEO_MEMORY_ADDRESS;

  for(i = 0; i < screen_size; i++){
    vidmem[i*2] = ' ';
    vidmem[i*2 + 1] = WHITE_ON_BLACK;
  }

  set_cursor_offset(0);
}

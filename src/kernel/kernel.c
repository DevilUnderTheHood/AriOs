#include "../drivers/screen.h"

void kernel_main(){
  clear_screen();
  print_at("Welcome to AriOs!\n", 0, 0);
  print_at("Developing a kernel is cool!!\n", -1, -1);
  print_at("The cursor is flowing like a damn river!!", -1, -1);
}

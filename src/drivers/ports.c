// Read bytes from specific port
unsigned char port_byte_in(unsigned short port){
  unsigned char result;
  // Inlined assmebly command
  __asm__("in %%dx,%%al" : "=a" (result) : "d" (port));
  return result;
}


void port_byte_out(unsigned short port, unsigned char data){
  // Inlined assmebly command
  __asm__("out %%al,%%dx": : "a" (data), "d" (port));
}

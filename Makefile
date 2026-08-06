CC=nasm -f elf64
LINKER=ld
DIRS=obj bin

$(DIRS):
	mkdir -p $@

rev_shellcode: $(DIRS)
	$(CC) reverse_shell/rev_tcp_shellcode.s -o ./obj/rev_tcp_shellcode.o
	$(LINKER) ./obj/rev_tcp_shellcode.o -o ./bin/rev_tcp_shellcode

shellcode: $(DIRS)
	$(CC) shell/shellcode.s -o ./obj/shellcode.o
	$(LINKER) obj/shellcode.o -o bin/shellcode

rev_tcp: $(DIRS)
	$(CC) reverse_shell/rev_tcp.s -o ./obj/rev_tcp.o
	$(LINKER) reverse_shell/rev_tcp.o -o ./bin/rev_tcp

runner: $(DIRS)
	gcc runner.c -o runner

clean: $(DIRS)
	$(RM) ./bin/*.bin ./obj/*.o ./bin/rev_shellcode ./bin/runner ./bin/shellcode ./bin/rev

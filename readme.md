A collection of cybersecurity-related programs written in NASM x86, just for fun


# To compile :
```
nasm -f elf64 <file.s>
ld file.o -o file
```

To extract shellcode :

```
objcopy -O binary --only-section=.text <file> file.bin
```

In C format :
```
xxd -i file.bin
```

In text format :
```
xxd -p file.bin | tr -d '\n' | sed 's/../\\x&/g'
```

# TODO :
- [ ] A simple shellcode to hijack SUID perms
- [ ] A simple Ransomware for the love of the game


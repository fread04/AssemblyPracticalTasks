# Practical Task 1: Add Three Integers
## Objective:
Create an assembly language program that adds three integers and stores the result in memory.
## Installation: 
```
nasm -f elf32 task1.asm
ld -m elf_i386 -o task1 task1.o -lc -dynamic-linker /lib/ld-linux.so.2
gdb ./task1
```
And to check correct answer:
```
(gdb) x/d &result
```

# Practical Task 3: Find the Maximum Value from Three Integers
## Objective:
Create an assembly language program that finds the maximum value from three integers and stores the result in memory.
## Installation: 
```
nasm -f elf32 task3.asm
ld -m elf_i386 -o task3 task3.o -lc -dynamic-linker /lib/ld-linux.so.2
./task3
```

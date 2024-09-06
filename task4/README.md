# Practical Task 4: Find the Maximum Value in an Array
## Objective:
Create an assembly language program that finds the maximum value in an array using conditional jumps and stores the result in memory.
## Installation: 
```
nasm -f elf32 task4.asm
ld -m elf_i386 -o task4 task4.o -lc -dynamic-linker /lib/ld-linux.so.2
./task4
```

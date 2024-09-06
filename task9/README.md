# Practical Task 9: Simple Calculator
## Objective:
Create a simple calculator program in assembly language that can perform basic arithmetic operations such as addition, subtraction, multiplication, and division.
## Installation: 
```
nasm -f elf32 task9.asm
ld -m elf_i386 -o task9 task9.o -lc -dynamic-linker /lib/ld-linux.so.2
./task9
```

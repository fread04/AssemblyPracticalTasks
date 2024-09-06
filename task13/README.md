# Practical Task 13: Create and Use Macros for Common Arithmetic Operations
## Objective:
Create an assembly language program that defines macros to perform common arithmetic operations (addition, subtraction, multiplication, and division) and uses these macros in a simple program.
## Installation: 
```
nasm -f elf32 task13.asm
ld -m elf_i386 -o task13 task13.o -lc -dynamic-linker /lib/ld-linux.so.2
./task13
```

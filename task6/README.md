# Practical Task 6: Calculate the Factorial of a Number Using Loop and Recursion
## Objective:
Create an assembly language program that defines two procedures to calculate the factorial of a number: one using a loop and the other using recursion. Store the results in memory and handle input from the keyboard and output to the console.
## Installation: 
```
nasm -f elf32 task6.asm
ld -m elf_i386 -o task6 task6.o -lc -dynamic-linker /lib/ld-linux.so.2
./task6
```

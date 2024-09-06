# Practical Task 10: Memory Segmentation by Accessing Data from Different Segments
## Objective:
Create an assembly language program that demonstrates memory segmentation by accessing and manipulating data from different segments. Implement functionality to encrypt data in one segment, transfer it to another segment, and decrypt it.
## Installation: 
```
nasm -f elf64 task10.asm -o task10.o
ld task10.o -o task10 -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
./task10
```

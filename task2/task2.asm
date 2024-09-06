section .data
    input db 'Hello, World!', 0  ; исходная строка
    len equ $-input              ; длина строки (без нулевого байта)

section .bss
    output resb len              ; буфер для перевернутой строки

section .text
    global _start

_start:
    ; указатели на начало и конец строки
    mov rsi, input               ; rsi указывает на начало строки
    mov rdi, output              ; rdi указывает на буфер для результата
    add rsi, len - 1             ; rsi указывает на последний символ строки

reverse_loop:
    mov al, [rsi]                ; прочитать символ с конца строки
    mov [rdi], al                ; записать его в буфер
    dec rsi                      ; сдвинуться влево по исходной строке
    inc rdi                      ; сдвинуться вправо по буферу
    cmp rsi, input - 1           ; проверка, не дошли ли до начала строки
    jg reverse_loop

    ; вывести перевернутую строку
    mov rax, 1                   ; системный вызов write
    mov rdi, 1                   ; дескриптор stdout
    mov rsi, output              ; адрес буфера с перевернутой строкой
    mov rdx, len                 ; длина строки
    syscall

    ; завершить программу
    mov rax, 60                  ; системный вызов exit
    xor rdi, rdi                 ; код завершения 0
    syscall
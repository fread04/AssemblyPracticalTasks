section .data
    prompt db "Введите выражение (например, 2+3-1): ", 0
    prompt_len equ $ - prompt
    result db "Результат: ", 0
    result_len equ $ - result
    newline db 10, 0

section .bss
    expression resb 100
    buffer resb 20

section .text
    global _start

_start:
    ; Выводим приглашение
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Читаем выражение
    mov rax, 0
    mov rdi, 0
    mov rsi, expression
    mov rdx, 100
    syscall

    ; Парсим и вычисляем выражение
    mov rsi, expression
    xor rax, rax  ; Инициализируем результат нулем
    xor rbx, rbx  ; Текущее число
    mov rcx, 1    ; Знак (1 для положительных, -1 для отрицательных)

parse_loop:
    movzx rdx, byte [rsi]
    cmp dl, 0
    je end_parse
    cmp dl, 10
    je end_parse
    
    cmp dl, '+'
    je process_operator
    cmp dl, '-'
    je process_operator
    
    ; Если это цифра, добавляем к текущему числу
    sub dl, '0'
    imul rbx, 10
    add rbx, rdx
    inc rsi
    jmp parse_loop

process_operator:
    ; Добавляем текущее число к результату
    imul rbx, rcx
    add rax, rbx
    xor rbx, rbx
    
    ; Устанавливаем знак для следующего числа
    mov rcx, 1
    cmp dl, '-'
    jne next_char
    mov rcx, -1

next_char:
    inc rsi
    jmp parse_loop

end_parse:
    ; Добавляем последнее число к результату
    imul rbx, rcx
    add rax, rbx

    ; Выводим строку "Результат: "
    mov rdi, 1
    mov rsi, result
    mov rdx, result_len
    push rax  ; Сохраняем результат
    mov rax, 1
    syscall
    pop rax   ; Восстанавливаем результат

    ; Преобразуем результат в строку и выводим
    mov rdi, buffer
    mov rsi, rax
    call int_to_string

    mov rdi, 1
    mov rsi, buffer
    mov rdx, rax
    mov rax, 1
    syscall

    ; Выводим новую строку
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    mov rax, 1
    syscall

    ; Завершаем программу
    mov rax, 60
    xor rdi, rdi
    syscall

; Функция для преобразования целого числа в строку
; rdi - указатель на буфер, rsi - число
; возвращает длину строки в rax
int_to_string:
    push rbx
    push rdx
    push rsi
    mov rbx, 10
    xor rcx, rcx  ; Счетчик цифр
    test rsi, rsi
    jns .positive
    neg rsi
    mov byte [rdi], '-'
    inc rdi
    inc rcx

.positive:
    mov rax, rsi

.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi+rcx+1], dl
    inc rcx
    test rax, rax
    jnz .loop

    lea rsi, [rdi+1]
    mov rdi, rsi
    mov rax, rcx
    pop rsi
    pop rdx
    pop rbx
    ret
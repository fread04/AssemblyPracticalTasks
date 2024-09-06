section .data
    msg_select db "Enter 0 for minimum or 1 for maximum: "
    msg_select_len equ $ - msg_select
    msg_result db "Result: "
    msg_result_len equ $ - msg_result
    newline db 10
    array db 10, 5, 8, 2, 7, 6, 1, 3, 9, 4
    array_len equ $ - array

section .bss
    choice resb 2  ; 1 byte for input, 1 byte for newline
    result resb 4  ; 3 digits for result and 1 for null terminator

section .text
    global _start

_start:
    ; Вывод сообщения выбора
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_select
    mov rdx, msg_select_len
    syscall

    ; Чтение ввода пользователя
    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 2
    syscall

    ; Преобразование выбора в число
    movzx rbx, byte [choice]
    sub rbx, '0'

    ; Инициализация переменных
    movzx rax, byte [array]  ; Начальное значение - первый элемент массива
    mov rcx, array_len
    mov rsi, array

    ; Если rbx = 1, то ищем максимум, иначе минимум
    cmp rbx, 1
    je find_max
    jmp find_min

find_max:
    ; Поиск максимума с развертыванием цикла
    sub rcx, 4  ; Уменьшаем счетчик на 4 (размер развертывания)
    jl handle_remaining_max  ; Если осталось меньше 4 элементов, обрабатываем их отдельно

find_max_loop:
    movzx rdx, byte [rsi]      ; Загружаем 4 элемента в регистры
    movzx rdi, byte [rsi + 1]
    movzx r8, byte [rsi + 2]
    movzx r9, byte [rsi + 3]

    cmp dl, al          ; Сравниваем каждый элемент с текущим максимумом
    cmovg rax, rdx
    cmp dil, al
    cmovg rax, rdi
    cmp r8b, al
    cmovg rax, r8
    cmp r9b, al
    cmovg rax, r9

    add rsi, 4          ; Переходим к следующим 4 элементам
    sub rcx, 4          ; Уменьшаем счетчик
    jge find_max_loop   ; Продолжаем, если осталось 4 или больше элементов

handle_remaining_max:
    add rcx, 4          ; Восстанавливаем счетчик для оставшихся элементов
    jz convert_result   ; Если элементов не осталось, переходим к конвертации результата

remaining_loop_max:
    movzx rdx, byte [rsi]   ; Загружаем оставшийся элемент
    cmp dl, al              ; Сравниваем с текущим максимумом
    cmovg rax, rdx          ; Обновляем максимум при необходимости
    inc rsi
    dec rcx
    jnz remaining_loop_max

    jmp convert_result

find_min:
    ; Поиск минимума с развертыванием цикла (аналогично поиску максимума)
    sub rcx, 4
    jl handle_remaining_min

find_min_loop:
    movzx rdx, byte [rsi]
    movzx rdi, byte [rsi + 1]
    movzx r8, byte [rsi + 2]
    movzx r9, byte [rsi + 3]

    cmp dl, al
    cmovl rax, rdx
    cmp dil, al
    cmovl rax, rdi
    cmp r8b, al
    cmovl rax, r8
    cmp r9b, al
    cmovl rax, r9

    add rsi, 4
    sub rcx, 4
    jge find_min_loop

handle_remaining_min:
    add rcx, 4
    jz convert_result

remaining_loop_min:
    movzx rdx, byte [rsi]
    cmp dl, al
    cmovl rax, rdx
    inc rsi
    dec rcx
    jnz remaining_loop_min

convert_result:
    ; Конвертация результата в строку
    mov rcx, 10
    mov rdi, result
    add rdi, 2  ; Начинаем с конца буфера (3 цифры максимум)
    mov byte [rdi + 1], 0  ; Null-terminator

convert_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz convert_loop

    ; Сдвигаем результат в начало буфера, если нужно
    inc rdi
    cmp rdi, result
    je print_result
    mov rsi, rdi
    mov rdi, result
    mov rcx, 3
    rep movsb

print_result:
    ; Вывод сообщения с результатом
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_result
    mov rdx, msg_result_len
    syscall

    ; Вывод значения результата
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 3  ; Максимальная длина результата
    syscall

    ; Вывод новой строки
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Завершение программы
    mov rax, 60
    xor rdi, rdi
    syscall
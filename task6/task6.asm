section .data
    msg_input db "Enter a positive integer: ", 0
    msg_result_loop db "Loop-based factorial: %d", 10, 0
    msg_result_rec db "Recursive factorial: %d", 10, 0
    format_in db "%d", 0   ; Формат для scanf

section .bss
    input_num resd 1       ; Место для хранения входного числа
    result_loop resd 1     ; Место для хранения результата цикла
    result_rec resd 1      ; Место для хранения результата рекурсии

section .text
    extern printf, scanf
    global _start

_start:
    ; Вывод сообщения запроса
    push msg_input
    call printf
    add esp, 4

    ; Чтение ввода пользователя
    push input_num
    push format_in
    call scanf
    add esp, 8

    ; Проверка, что введенное число положительное
    mov eax, [input_num]
    cmp eax, 0
    jl exit_program

    ; Вызов процедуры вычисления факториала с помощью цикла
    mov eax, [input_num]
    call factorial_loop
    mov [result_loop], eax

    ; Вызов процедуры вычисления факториала с помощью рекурсии
    mov eax, [input_num]
    call factorial_rec
    mov [result_rec], eax

    ; Вывод результатов
    push dword [result_loop]
    push msg_result_loop
    call printf
    add esp, 8

    push dword [result_rec]
    push msg_result_rec
    call printf
    add esp, 8

exit_program:
    ; Завершение программы
    xor ebx, ebx
    mov eax, 1
    int 0x80

; Факториал с помощью цикла
factorial_loop:
    ; Входное значение - eax
    mov ecx, eax            ; Счетчик цикла
    mov eax, 1              ; Результат

factorial_loop_start:
    mul ecx                 ; Умножение eax на ecx
    loop factorial_loop_start
    ret

; Факториал с помощью рекурсии
factorial_rec:
    ; Входное значение - eax
    cmp eax, 1
    jle factorial_rec_base_case
    push eax
    dec eax
    call factorial_rec
    pop ebx
    mul ebx
    ret

factorial_rec_base_case:
    mov eax, 1
    ret

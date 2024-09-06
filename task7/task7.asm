section .data
    msg_input db "Enter a positive integer: "
    msg_input_len equ $ - msg_input
    msg_result_loop db "Loop-based factorial: "
    msg_result_loop_len equ $ - msg_result_loop
    msg_result_rec db 10, "Recursive factorial: "
    msg_result_rec_len equ $ - msg_result_rec
    newline db 10

section .bss
    input_num resq 1       ; Место для хранения входного числа (64 бит)
    result_loop resq 1     ; Место для хранения результата цикла (64 бит)
    result_rec resq 1      ; Место для хранения результата рекурсии (64 бит)
    input_buffer resb 20   ; Буфер для ввода
    output_buffer resb 20  ; Буфер для вывода

section .text
    global _start

_start:
    ; Вывод сообщения запроса
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_input
    mov rdx, msg_input_len
    syscall

    ; Чтение ввода пользователя
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 20
    syscall

    ; Преобразование строки в число
    mov rsi, input_buffer
    xor rax, rax
    xor rcx, rcx
.convert_loop:
    movzx rdx, byte [rsi + rcx]
    cmp rdx, 10  ; Проверка на символ новой строки
    je .convert_done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rcx
    jmp .convert_loop
.convert_done:
    mov [input_num], rax

    ; Проверка, что введенное число положительное
    test rax, rax
    jle exit_program

    ; Вызов процедуры вычисления факториала с помощью цикла
    mov rdi, [input_num]
    call factorial_loop
    mov [result_loop], rax

    ; Вызов процедуры вычисления факториала с помощью рекурсии
    mov rdi, [input_num]
    mov rsi, 1              ; Начальное значение аккумулятора
    call factorial_rec
    mov [result_rec], rax

    ; Вывод результатов
    mov rdi, msg_result_loop
    mov rsi, msg_result_loop_len
    call print_string
    mov rax, [result_loop]
    call print_number

    mov rdi, msg_result_rec
    mov rsi, msg_result_rec_len
    call print_string
    mov rax, [result_rec]
    call print_number

exit_program:
    ; Завершение программы
    mov rax, 60
    xor rdi, rdi
    syscall

; Функция для вывода строки
; rdi - адрес строки, rsi - длина строки
print_string:
    mov rax, 1
    mov rdx, rsi
    mov rsi, rdi
    mov rdi, 1
    syscall
    ret

; Функция для вывода числа
; rax - число для вывода
print_number:
    mov rdi, output_buffer
    add rdi, 19
    mov byte [rdi], 0
    mov rbx, 10
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .loop
    mov rsi, rdi
    mov rdx, output_buffer
    add rdx, 20
    sub rdx, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

; Факториал с помощью цикла (с развертыванием цикла)
factorial_loop:
    mov rax, 1              ; Результат
    mov rcx, rdi            ; Счетчик цикла
    cmp rcx, 4
    jl .small_number

.unrolled_loop:
    mul rcx                 ; Умножение на текущее число
    dec rcx
    mul rcx                 ; Умножение на (текущее число - 1)
    dec rcx
    mul rcx                 ; Умножение на (текущее число - 2)
    dec rcx
    mul rcx                 ; Умножение на (текущее число - 3)
    dec rcx
    cmp rcx, 4
    jge .unrolled_loop

.small_number:
    cmp rcx, 1
    jle .done
.small_loop:
    mul rcx
    dec rcx
    cmp rcx, 1
    jg .small_loop

.done:
    ret

; Факториал с помощью рекурсии (с оптимизацией хвостовой рекурсии)
; rdi - текущее число, rsi - аккумулятор
factorial_rec:
    cmp rdi, 1
    jle .base_case
    mov rax, rsi
    mul rdi                 ; Умножаем аккумулятор на текущее число
    mov rsi, rax            ; Обновляем аккумулятор
    dec rdi                 ; Уменьшаем счетчик
    jmp factorial_rec       ; Продолжаем рекурсию

.base_case:
    mov rax, rsi            ; Возвращаем результат
    ret
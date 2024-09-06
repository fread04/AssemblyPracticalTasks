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
    result resb 11 ; Up to 10 digits for 32-bit number and 1 for null terminator

section .text
    global _start

_start:
    ; Вывод сообщения выбора
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_select
    mov edx, msg_select_len
    int 0x80

    ; Чтение ввода пользователя
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 0x80

    ; Преобразование выбора в число
    movzx ebx, byte [choice]
    sub ebx, '0'

    ; Инициализация переменных
    movzx eax, byte [array]
    mov ecx, array_len
    lea esi, [array]

    ; Если ebx = 1, то ищем максимум
    cmp ebx, 1
    je find_max

find_min:
    ; Поиск минимума
find_min_loop:
    movzx edi, byte [esi]
    cmp edi, eax
    jge next_element
    mov eax, edi
next_element:
    inc esi
    loop find_min_loop
    jmp convert_result

find_max:
    ; Поиск максимума
    mov eax, 0
find_max_loop:
    movzx edi, byte [esi]
    cmp edi, eax
    jle next_element_max
    mov eax, edi
next_element_max:
    inc esi
    loop find_max_loop

convert_result:
    ; Конвертация результата в строку
    mov ecx, 10
    mov edi, result
    add edi, 9  ; Начинаем с конца буфера
    mov byte [edi+1], 0  ; Null-terminator

convert_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_loop

    ; Сдвигаем результат в начало буфера
    inc edi
    mov esi, edi
    mov edi, result
    mov ecx, 10
    rep movsb

print_result:
    ; Вывод сообщения с результатом
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result
    mov edx, msg_result_len
    int 0x80

    ; Вывод значения результата
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10  ; Максимальная длина результата
    int 0x80

    ; Вывод новой строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Завершение программы
    mov eax, 1
    xor ebx, ebx
    int 0x80
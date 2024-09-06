section .data
    array dd 64, 34, 25, 12, 22, 11, 90   ; Исходный массив
    array_len equ ($ - array) / 4         ; Длина массива
    msg_unsorted db "Unsorted array: ", 0
    msg_sorted db "Sorted array: ", 0
    fmt db "%d ", 0                       ; Формат для вывода чисел
    newline db 10, 0                      ; Символ новой строки

section .bss
    sorted_array resd array_len           ; Резервируем память для отсортированного массива

section .text
    global _start
    extern printf

_start:
    ; Вывод неотсортированного массива
    push msg_unsorted
    call printf
    add esp, 4
    lea esi, [array]
    call print_array

    ; Копирование исходного массива в sorted_array
    mov ecx, array_len
    lea esi, [array]
    lea edi, [sorted_array]
    rep movsd

    ; Вызов процедуры сортировки
    push array_len
    push sorted_array
    call bubble_sort
    add esp, 8

    ; Вывод отсортированного массива
    push msg_sorted
    call printf
    add esp, 4
    lea esi, [sorted_array]
    call print_array

    ; Выход из программы
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Процедура сортировки пузырьком
bubble_sort:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov esi, [ebp + 8]    ; Адрес массива
    mov ecx, [ebp + 12]   ; Длина массива
    dec ecx               ; Уменьшаем на 1 для правильного количества проходов

.outer_loop:
    xor ebx, ebx          ; Флаг обмена
    mov edi, esi          ; Начало массива
    mov edx, ecx          ; Сохраняем количество элементов для внутреннего цикла

.inner_loop:
    mov eax, [edi]        ; Текущий элемент
    cmp eax, [edi + 4]    ; Сравниваем с следующим
    jle .no_swap          ; Если текущий <= следующего, не меняем

    ; Обмен элементов
    xchg eax, [edi + 4]
    mov [edi], eax
    mov ebx, 1            ; Устанавливаем флаг обмена

.no_swap:
    add edi, 4            ; Переход к следующему элементу
    dec edx               ; Уменьшаем счетчик
    jnz .inner_loop       ; Если не ноль, продолжаем внутренний цикл

    test ebx, ebx         ; Проверяем, был ли обмен
    jnz .outer_loop       ; Если был, повторяем внешний цикл

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; Процедура вывода массива
print_array:
    push ebp
    mov ebp, esp
    push esi
    push ecx

    mov ecx, array_len
.loop:
    push ecx
    mov eax, [esi]
    push eax
    push fmt
    call printf
    add esp, 8
    pop ecx
    add esi, 4
    loop .loop

    push newline
    call printf
    add esp, 4

    pop ecx
    pop esi
    pop ebp
    ret

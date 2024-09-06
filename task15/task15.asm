section .data
    prompt_mode db "Выберите режим (0 - шифрование, 1 - дешифрование): ", 0
    prompt_input db "Введите путь к входному файлу: ", 0
    prompt_output db "Введите путь к выходному файлу: ", 0
    error_msg db "Ошибка при выполнении операции", 10, 0
    success_msg db "Операция выполнена успешно", 10, 0
    key db 0x12, 0x34, 0x56, 0x78  ; Ключ шифрования (4 байта)

section .bss
    mode resb 2
    input_path resb 256
    output_path resb 256
    buffer resb 1024

section .text
    global _start

_start:
    ; Запрос режима работы
    mov rdi, prompt_mode
    call print_string
    mov rdi, mode
    mov rsi, 2
    call read_string
    
    ; Проверка режима
    mov al, [mode]
    sub al, '0'
    cmp al, 0
    jl .error
    cmp al, 1
    jg .error

    ; Запрос пути к входному файлу
    mov rdi, prompt_input
    call print_string
    mov rdi, input_path
    mov rsi, 256
    call read_string

    ; Запрос пути к выходному файлу
    mov rdi, prompt_output
    call print_string
    mov rdi, output_path
    mov rsi, 256
    call read_string

    ; Открытие входного файла
    mov rax, 2  ; sys_open
    mov rdi, input_path
    xor rsi, rsi  ; O_RDONLY
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl .error
    mov r12, rax  ; Сохраняем дескриптор входного файла

    ; Открытие выходного файла
    mov rax, 2  ; sys_open
    mov rdi, output_path
    mov rsi, 0q102  ; O_WRONLY | O_CREAT
    mov rdx, 0q666  ; Права доступа
    syscall
    cmp rax, 0
    jl .error
    mov r13, rax  ; Сохраняем дескриптор выходного файла

    ; Обработка файла
.process_loop:
    mov rax, 0  ; sys_read
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 1024
    syscall
    cmp rax, 0
    jle .end_process

    mov rcx, rax  ; Количество прочитанных байт
    mov rsi, buffer
    mov rdi, key
    call xor_data

    mov rdx, rax  ; Количество байт для записи
    mov rax, 1  ; sys_write
    mov rdi, r13
    mov rsi, buffer
    syscall

    jmp .process_loop

.end_process:
    ; Закрытие файлов
    mov rax, 3  ; sys_close
    mov rdi, r12
    syscall

    mov rax, 3  ; sys_close
    mov rdi, r13
    syscall

    ; Вывод сообщения об успехе
    mov rdi, success_msg
    call print_string

    ; Завершение программы
    mov rax, 60  ; sys_exit
    xor rdi, rdi
    syscall

.error:
    ; Вывод сообщения об ошибке
    mov rdi, error_msg
    call print_string
    mov rax, 60  ; sys_exit
    mov rdi, 1
    syscall

; Функция для вывода строки
; rdi - указатель на строку
print_string:
    push rdi
    mov rax, 1  ; sys_write
    mov rsi, rdi
    mov rdx, 0
.count:
    inc rdx
    cmp byte [rsi + rdx - 1], 0
    jne .count
    dec rdx
    mov rdi, 1  ; stdout
    pop rsi
    syscall
    ret

; Функция для чтения строки
; rdi - буфер для чтения
; rsi - максимальная длина
read_string:
    push rdi
    push rsi
    mov rax, 0  ; sys_read
    mov rsi, rdi
    mov rdx, rsi
    mov rdi, 0  ; stdin
    syscall
    pop rdx
    pop rdi
    dec rax
    mov byte [rdi + rax], 0  ; Заменяем \n на \0
    ret

; Функция XOR-шифрования
; rsi - указатель на данные
; rdi - указатель на ключ
; rcx - длина данных
xor_data:
    xor rax, rax        ; Счетчик байтов
    mov r8, 4           ; Длина ключа
.loop:
    mov dl, [rsi + rax] ; Читаем байт данных
    mov r9, rax
    and r9, r8 - 1      ; r9 = rax % r8 (аналог деления по модулю)
    xor dl, [rdi + r9]  ; XOR с соответствующим байтом ключа
    mov [rsi + rax], dl ; Записываем зашифрованный байт обратно
    inc rax             ; Увеличиваем счетчик байтов
    cmp rax, rcx        ; Сравниваем с длиной данных
    jl .loop            ; Повторяем цикл, если не достигли конца данных
    ret

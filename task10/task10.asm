section .data
    ; Исходная строка
    original db 'Hello, World!', 0
    ; Размер строки (без нулевого байта)
    original_len equ $ - original

    ; Метки для строк
    msg_original db 'Original: ', 0
    msg_encrypted db 'Encrypted: ', 0
    msg_decrypted db 'Decrypted: ', 0
    newline db 10, 0  ; Символ переноса строки (LF)

section .bss
    ; Буфер для зашифрованной строки
    encrypted resb 256
    ; Буфер для расшифрованной строки
    decrypted resb 256

section .text
    global _start

_start:
    ; Вывод исходной строки
    mov rsi, msg_original    ; Адрес метки для исходной строки
    call print_string
    mov rsi, original        ; Адрес исходной строки
    call print_string

    ; Перенос строки
    mov rsi, newline         ; Адрес символа переноса строки
    call print_string

    ; Шифрование строки
    mov rsi, original        ; Адрес исходной строки
    mov rdi, encrypted       ; Адрес буфера для зашифрованной строки
    mov rcx, original_len    ; Размер строки
    call encrypt_string

    ; Вывод зашифрованной строки
    mov rsi, msg_encrypted   ; Адрес метки для зашифрованной строки
    call print_string
    mov rsi, encrypted       ; Адрес зашифрованной строки
    call print_string

    ; Перенос строки
    mov rsi, newline         ; Адрес символа переноса строки
    call print_string

    ; Дешифрование строки
    mov rsi, encrypted       ; Адрес зашифрованной строки
    mov rdi, decrypted       ; Адрес буфера для расшифрованной строки
    mov rcx, original_len    ; Размер строки
    call decrypt_string

    ; Вывод расшифрованной строки
    mov rsi, msg_decrypted   ; Адрес метки для расшифрованной строки
    call print_string
    mov rsi, decrypted       ; Адрес расшифрованной строки
    call print_string

    ; Перенос строки
    mov rsi, newline         ; Адрес символа переноса строки
    call print_string

    ; Завершение программы
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; Код возврата 0
    syscall

; Процедура шифрования строки
encrypt_string:
    mov rbx, 3              ; Сдвиг шифра
encrypt_loop:
    mov al, [rsi]          ; Получить символ из строки
    cmp al, 0              ; Проверить конец строки
    je encrypt_done
    add al, bl             ; Сдвинуть символ
    mov [rdi], al          ; Сохранить зашифрованный символ
    inc rsi                ; Перейти к следующему символу
    inc rdi
    loop encrypt_loop
encrypt_done:
    mov byte [rdi], 0      ; Завершить строку нулем
    ret

; Процедура дешифрования строки
decrypt_string:
    mov rbx, 3              ; Сдвиг шифра
decrypt_loop:
    mov al, [rsi]          ; Получить символ из строки
    cmp al, 0              ; Проверить конец строки
    je decrypt_done
    sub al, bl             ; Обратить сдвиг
    mov [rdi], al          ; Сохранить расшифрованный символ
    inc rsi                ; Перейти к следующему символу
    inc rdi
    loop decrypt_loop
decrypt_done:
    mov byte [rdi], 0      ; Завершить строку нулем
    ret

; Процедура вывода строки
print_string:
    ; Определить длину строки
    mov rax, rsi           ; Сохранить адрес строки
    mov rdx, 0             ; Сбросить счетчик длины
find_length:
    cmp byte [rax + rdx], 0 ; Проверить конец строки
    je print_string_done
    inc rdx                ; Увеличить счетчик длины
    jmp find_length
print_string_done:
    ; Установить параметры для sys_write
    mov rax, 1             ; sys_write
    mov rdi, 1             ; Файловый дескриптор 1 (stdout)
    syscall
    ret

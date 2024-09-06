section .data
    num1 dd 10
    num2 dd 5
    result dd 0
    fmt_str db "Result: %d", 10, 0  ; Format string for printf

section .text
    global _start
    extern printf

; Macro Definitions
%macro ADD_MACRO 3
    mov eax, [%1]
    add eax, [%2]
    mov [%3], eax
%endmacro

%macro SUB_MACRO 3
    mov eax, [%1]
    sub eax, [%2]
    mov [%3], eax
%endmacro

%macro MUL_MACRO 3
    mov eax, [%1]
    imul dword [%2]
    mov [%3], eax
%endmacro

%macro DIV_MACRO 3
    mov eax, [%1]
    cdq
    idiv dword [%2]
    mov [%3], eax
%endmacro

_start:
    ; Addition
    ADD_MACRO num1, num2, result
    push dword [result]
    push fmt_str
    call printf
    add esp, 8

    ; Subtraction
    SUB_MACRO num1, num2, result
    push dword [result]
    push fmt_str
    call printf
    add esp, 8

    ; Multiplication
    MUL_MACRO num1, num2, result
    push dword [result]
    push fmt_str
    call printf
    add esp, 8

    ; Division
    DIV_MACRO num1, num2, result
    push dword [result]
    push fmt_str
    call printf
    add esp, 8

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
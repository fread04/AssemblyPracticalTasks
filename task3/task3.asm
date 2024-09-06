section .data
    prompt_num db "Enter integer %d: ", 0
    prompt_op db "Enter 1 for maximum or 0 for minimum: ", 0
    result_msg db "The %s value is: %d", 10, 0
    max_str db "maximum", 0
    min_str db "minimum", 0
    input_format db "%d", 0

section .bss
    num1 resd 1
    num2 resd 1
    num3 resd 1
    result resd 1
    operation resd 1

section .text
    global _start
    extern printf, scanf, exit

_start:
    ; Input three numbers
    push ebp
    mov ebp, esp

    ; Input num1
    push 1
    push prompt_num
    call printf
    add esp, 8
    push num1
    push input_format
    call scanf
    add esp, 8

    ; Input num2
    push 2
    push prompt_num
    call printf
    add esp, 8
    push num2
    push input_format
    call scanf
    add esp, 8

    ; Input num3
    push 3
    push prompt_num
    call printf
    add esp, 8
    push num3
    push input_format
    call scanf
    add esp, 8

    ; Input operation (max or min)
    push prompt_op
    call printf
    add esp, 4
    push operation
    push input_format
    call scanf
    add esp, 8

    ; Load the three integers into registers
    mov eax, [num1]
    mov ebx, [num2]
    mov ecx, [num3]

    ; Check if we're finding max or min
    cmp dword [operation], 0
    je find_min

find_max:
    ; Compare num1 and num2
    cmp eax, ebx
    jge compare_num1_num3_max
    mov eax, ebx

compare_num1_num3_max:
    cmp eax, ecx
    jge store_result
    mov eax, ecx
    jmp store_result

find_min:
    ; Compare num1 and num2
    cmp eax, ebx
    jle compare_num1_num3_min
    mov eax, ebx

compare_num1_num3_min:
    cmp eax, ecx
    jle store_result
    mov eax, ecx

store_result:
    mov [result], eax

    ; Print the result
    push dword [result]
    mov edx, max_str
    cmp dword [operation], 0
    jne print_result
    mov edx, min_str

print_result:
    push edx
    push result_msg
    call printf
    add esp, 12

    ; Exit the program
    push 0
    call exit
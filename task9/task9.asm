section .data
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    prompt_op db "Select operation (1:+, 2:-, 3:*, 4:/): ", 0
    result_msg db "Result: %d", 10, 0
    div_error db "Error: Division by zero", 10, 0
    continue_prompt db "Continue? (1: Yes, 0: No): ", 0
    input_format db "%d", 0

section .bss
    num1 resd 1
    num2 resd 1
    operation resd 1
    result resd 1
    continue_flag resd 1

section .text
    global _start
    extern printf, scanf

_start:
    call calculator_loop
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

calculator_loop:
    ; Get first number
    push prompt1
    call printf
    add esp, 4
    push num1
    push input_format
    call scanf
    add esp, 8

    ; Get second number
    push prompt2
    call printf
    add esp, 4
    push num2
    push input_format
    call scanf
    add esp, 8

    ; Get operation
    push prompt_op
    call printf
    add esp, 4
    push operation
    push input_format
    call scanf
    add esp, 8

    ; Perform calculation
    mov eax, [num1]
    mov ebx, [num2]
    mov ecx, [operation]

    cmp ecx, 1
    je add_op
    cmp ecx, 2
    je sub_op
    cmp ecx, 3
    je mul_op
    cmp ecx, 4
    je div_op

    jmp print_result  ; Invalid operation, just print the result (which is unmodified)

add_op:
    add eax, ebx
    jmp print_result

sub_op:
    sub eax, ebx
    jmp print_result

mul_op:
    imul eax, ebx
    jmp print_result

div_op:
    test ebx, ebx
    jz div_by_zero
    cdq
    idiv ebx
    jmp print_result

div_by_zero:
    push div_error
    call printf
    add esp, 4
    jmp check_continue

print_result:
    mov [result], eax
    push eax
    push result_msg
    call printf
    add esp, 8

check_continue:
    push continue_prompt
    call printf
    add esp, 4
    push continue_flag
    push input_format
    call scanf
    add esp, 8

    mov eax, [continue_flag]
    test eax, eax
    jnz calculator_loop

    ret
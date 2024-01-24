section .data
    arg_err: db "Faltou o argumento", 20h, 3Ah, 28h, 0Ah
    arg_len: equ $ - arg_err
    msg_err: db "Não existe quantidade negativa", 20h, 3Ah, 28h, 0Ah
    err_len: equ $ - msg_err
    star: db "*"
    newline: db 0Ah

section .text
    global _start

_start:
    pop rcx
    cmp rcx, 1
    jz _arg_error

    pop rdi
    pop rdi
    call stoi

    mov rdi, rax
    call gen_stars
    test rax, rax
    jz _exit

    mov rax, 01h
    mov rdi, 1
    mov rsi, msg_err
    mov rdx, err_len
    syscall
    jmp _exit

_arg_error:
    mov rax, 01h
    mov rdi, 1
    mov rsi, arg_err
    mov rdx, arg_len
    syscall

_exit:
    mov rdi, rax
    mov rax, 3Ch
    syscall

stoi:
    xor rdx, rdx
    xor r8, r8

_stoi_loop:
    xor rcx, rcx
    mov cl, [rdi]
    test cl, cl
    jz _stoi_return
    cmp cl, '-'
    je _minus

    mov rax, 10
    mul rdx
    mov rdx, rax
    sub cl, 30h
    add rdx, rcx
    inc rdi
    jmp _stoi_loop

_minus:
    mov r8, 8000000000000000h 
    inc rdi
    jmp _stoi_loop

_stoi_return:
    mov rax, rdx
    or rax, r8
    ret

gen_stars:
    push rbx
    push r8
    push r9

    cmp rdi, 0
    jl _negative

    mov rbx, rdi
    xor r8, r8
_loop_line:
    cmp r8, rbx
    jz _positive

    inc r8
    xor r9, r9
_loop_stars:
    mov rax, 01h
    mov rdi, 1
    mov rsi, star
    mov rdx, 1
    syscall
    inc r9
    cmp r9, r8
    jnz _loop_stars

    mov rax, 01h
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    jmp _loop_line

_negative:
    dec rax
    jmp _return

_positive:
    xor rax, rax

_return:
    pop r9
    pop r8
    pop rbx
    ret

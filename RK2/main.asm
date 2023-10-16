section .data
    
section .bss
    Inbuf resb 255
    lenIn equ $-Inbuf
    substring resb 50
    lenSub equ $-substring
    Buf resb 10
    lenBuf equ $-Buf
    global _start
section .text
_start:
    
    mov eax, 3
    mov ebx, 0
    mov ecx, Inbuf
    mov edx, lenIn
    int 80h
    
    mov ecx, 255
    mov edi, Inbuf
    mov al, 0ah
    repne scasb
    mov eax, 254
    sub eax, ecx
    mov byte[Inbuf + eax], ' '
    mov ecx, eax
    inc ecx

    mov edx, 0
    mov eax, 0
    mov ebx, 0
    mov edi, 0

    loop_one:
        mov al, [Inbuf + ebx]
        cmp al, ' '
        je space
            mov [substring + edx], al
            inc ebx
            inc edx
            loop loop_one
            jmp finish
        space:
            push ebx
            push ecx
            push edx
            mov ecx, edx
            mov ebx, 0
            mov edx, 0
            mov esi, 0
            loop_find_digit:
                mov al, [substring + ebx]
                cmp al, '0'
                je digit
                cmp al, '1'
                je digit
                cmp al, '2'
                je digit
                cmp al, '3'
                je digit
                cmp al, '4'
                je digit
                cmp al, '5'
                je digit
                cmp al, '6'
                je digit
                cmp al, '7'
                je digit
                cmp al, '8'
                je digit
                cmp al, '9'
                je digit
                    inc edx
                    inc ebx
                    loop loop_find_digit
                    jmp end_find_digit
                digit:
                    inc esi
                    inc ebx
                    loop loop_find_digit
                end_find_digit:
                    cmp esi, 2
                    jg greater
                    jmp smaller
                    greater:
                        inc edi
                        mov eax, edx
                        mov esi, Buf
                        call IntToStr
                        mov edx, eax
                        mov eax, 4
                        mov ebx, 1
                        mov ecx, esi
                        int 80h
                    smaller:
                        pop edx
                        mov ecx, edx
                        mov edx, 0
                    loop_space_substr:
                        mov byte[substring + edx], ' '
                        inc edx
                        loop loop_space_substr
                    mov edx, 0
                    pop ecx
                    pop ebx
                    inc ebx
                    dec ecx
                    jnz loop_one
    finish:
        mov eax, edi
        mov esi, Buf
        call IntToStr
        mov edx, eax
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        int 80h
        mov eax, 1
        xor ebx, ebx
        int 80h
%include "../lib.asm"

    
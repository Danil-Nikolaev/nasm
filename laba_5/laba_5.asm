    section .data
EnterMsg db "Enter string:",10
lenM equ $-EnterMsg

RezBuf times 16 db " "
count dw 0

save times 8 db " "
    section .bss
result_array resw 4

InBuf resb 35
lenIn equ $-InBuf

OutBuf resw 10
lenOut equ $-OutBuf

    section .text
    global _start
    _start:
; Выведем сообщение на просьбу вывести строку
mov eax, 4
mov ebx, 1
mov ecx, EnterMsg
mov edx, lenM
int 80h
; Вводим строку
mov eax, 3
mov ebx, 0
mov ecx, InBuf
mov edx, lenIn
int 80h
; заполним 

; в esi кладем введенную строку
lea esi, [InBuf]
mov al, " " ; в al кладём пробел
mov ebx, 0 ; ebx счётчик уникальных символов в слове
mov ecx, 35 ; количество повторений (4 слова * 8 символов + 3 пробела между словами)
mov edx, 0
cld ; обнуляем флаг df

loop_one:   
    lodsb
    cmp EAX, " "
    je space
        lea edi, [save]
        push ecx
        mov ecx, 8
        repne scasb
        pop ecx
        je find
        mov [ebx + save], al
        inc ebx
        loop loop_one
        jmp continue
    space:
        lea edi, [save]
        mov al, " "
        push ecx
        mov ecx, 8
        rep stosb
        pop ecx
        mov [2*edx + result_array], ebx
        mov ebx, 0
        inc edx
        loop loop_one
        jmp continue
    find:
            loop loop_one
; Вывод результатов
continue:
    mov [2*edx + result_array], ebx
    mov ECX, 4
    mov EBX, 0
cycle4:
    push ECX
    mov esi, OutBuf
    mov ax, [EBX * 2 + result_array]
    inc EBX
    cwde
    call IntToStr
    mov edx, eax
    mov eax, 4
    push EBX
    mov ebx, 1
    mov ecx, esi
    int 80h
    pop EBX
    pop ECX
    loop cycle4

; Конец программы
mov eax, 1; системная функция 1 (exit)
xor ebx, ebx; код возврата 0
int 80h
%include "../lib.asm"

    section .data
OpenMSG dw "Input 3 variable", 10
lenOpen equ $-OpenMSG
    section .bss
;Резервируем место для переменных
A resw 1
B resw 1
K resw 1
; Резервируем место для результата
S resw 1

InBuf   resw    10
lenIn   equ     $-InBuf

OutBuf resw 10
lenOut equ $-OutBuf

    section .text
global _start
_start:
    ; Выведем сообщение с просьбой ввести 3 переменных
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, OpenMSG
    mov     edx, lenOpen
    int     80h
    ; Просим ввести переменные
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, InBuf
    mov     edx, lenIn
    int     80h
    ;Преобразуем строку в число
    mov esi, InBuf
    call StrToInt
    mov [A], EAX

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, InBuf
    mov     edx, lenIn
    int     80h

    mov esi, InBuf
    call StrToInt

    mov [B], EAX

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, InBuf
    mov     edx, lenIn
    int     80h

    mov esi, InBuf
    call StrToInt

    mov [K], EAX

    ; Вычисление выражения
    mov EAX,[A]
    mov EBX,[B]
    mov ECX,2
    imul EBX ; EBX:EAX := A * B
    ; xor   edx, edx ;
    cwde
    cdq
    idiv ECX ; EAX = (EBX:EAX)/ 2
    mov EBX, [K]
    sub EAX, EBX
    mov EBX, EAX
    mov edx, 0
    mov EAX, [A]
    mov ECX, 3
    cwde
    cdq
    idiv ECX ; EAX = A/3
    sub EAX, [B] ; EAX = EAX - B
    add EBX, EAX
    mov [S], EBX

    ;Выведем на экран результат
    mov esi, OutBuf
    mov ax, [S]
    cwde
    call IntToStr
    mov edx, eax
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, esi
    int     80h

    mov eax, 1; системная функция 1 (exit)
    xor ebx, ebx; код возврата 0
    int 80h
%include "../lib.asm"

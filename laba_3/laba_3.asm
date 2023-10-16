section .data
    OpenMSG dw "Please input 2 variable", 10
    lenOpen equ $-OpenMSG
section .bss
    A resw 1
    B resw 1
    X resw 1
    f resw 1
    InBuf   resw    10
    lenIn   equ     $-InBuf
    OutBuf resw 10
    lenOut equ $-OutBuf
section .text
    global _start
    _start:
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, OpenMSG
        mov     edx, lenOpen
        int     80h

        ; Просим ввести переменные
        mov     eax, 3 ; системная функци 3 (read)
        mov     ebx, 0 ; stdin = 0
        mov     ecx, InBuf ; адерс вводимой переменной
        mov     edx, lenIn ; длина строки
        int     80h ; вызываем системную функцию
        ;Преобразуем строку в число
        mov esi, InBuf ; адрес буфера вывожа
        call StrToInt ; вызываем функцию из библиотеки

        mov [A], EAX ; результат сохраням в переменную A



        mov     eax, 3
        mov     ebx, 0
        mov     ecx, InBuf
        mov     edx, lenIn
        int     80h

        mov esi, InBuf
        call StrToInt

        mov [X], EAX

        mov EAX, [A]
        mov EBX, [X]
        imul EBX
        ;xor EDX, EDX
        mov ECX, 2
        cwde 
        cdq
        idiv ECX

        cmp EDX, 0
        jne else
        mov [f], EAX
        jmp continue
    else:
        mov     eax, 3
        mov     ebx, 0
        mov     ecx, InBuf
        mov     edx, lenIn
        int     80h

        mov esi, InBuf
        call StrToInt

        mov [B], EAX

        mov EAX, [A]
        mov EBX, [X]
        imul EBX
        mov ECX, EAX
        mov EAX, [B]
        imul EAX
        mov EBX, [B]
        imul EBX
        sub ECX, EAX
        mov [f], ECX
    continue:
        mov esi, OutBuf ; загрузка адреса буфера вывода
        mov ax, [f] ; сохраняем результат в ax
        cwde ; расширяем ax до eax
        call IntToStr ; преобразуем число в строку
         mov edx, eax ; в edx кладем длину строки
        mov     eax, 4 ; системная функция вывода
        mov     ebx, 1 ; stdout = 1 
        mov     ecx, esi ; в ecx адрес выводимой строки
        int     80h ; вызываем системную функцию

        ; Конец программы
        mov eax, 1; системная функция 1 (exit)
        xor ebx, ebx; код возврата 0
        int 80h
%include "../lib.asm"

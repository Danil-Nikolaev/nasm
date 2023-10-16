    section .data
NewLine db 10
rows dw 4
columns dw 6
numElem dw 0
    section .bss
mas resw 24
InBuf   resw    10
lenIn   equ     $-InBuf
X resw 1
OutBuf resw 10
lenOut equ $-OutBuf
    section .text
global _start
_start:
; Введём 24 числа с помощью счетного цикла
mov ECX, 24
cycle:
    mov [X], ECX
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h
    mov esi, InBuf
    call StrToInt
    mov EBX, [numElem]
    mov [EBX*2+mas], EAX
    add EBX, 1
    mov [numElem], EBX
    mov ECX, [X]
    loop cycle
mov ECX, 4
mov EBX, 0
cycle2: push ECX
    mov ECX, 6
    mov AX, 0
    cycle3:
        mov DX, [EBX* 2 + mas]
        cmp DX, 0
        jl true
        jmp continue
        true:
            add AX, [EBX*2 + mas]
        continue:
        inc EBX
        loop cycle3
    pop ECX
    cmp AX, 0
    jne smaller_zero
        jmp continue2
    smaller_zero:
        mov [(EBX - 6) * 2 + mas], AX
    continue2:
    loop cycle2
mov ECX, 4
mov EBX, 0
cycle4:
    push ECX
    mov ecx, 6
    cycle5:
        push ecx
        mov esi, OutBuf
        mov ax, [EBX * 2 + mas]
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
        pop ecx
        loop cycle5
    push ebx
    mov     eax, 4          
    mov     ebx, 1          
    mov     ecx, NewLine   
    mov     edx, 1 
    int     80h    
    pop ebx   
    pop ECX
    loop cycle4

; Конец программы
mov eax, 1; системная функция 1 (exit)
xor ebx, ebx; код возврата 0
int 80h
%include "../lib.asm"

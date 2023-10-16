section .data
  rows dw 6
  cols dw 6
  matr dw 1, 2, 3, 4, 5, 6
       dw 7, 8, 9, 10, 11, 12
       dw 13, 14, 15, 16, 17, 18
       dw 19, 20, 21, 22, 23, 24
       dw 25, 26, 27, 28, 29, 30
       dw 31, 32, 33, 34, 35, 36
  new_line db 10

section .bss
  out_buf resw 10
  len_out equ $-out_buf

global _start

section .text
  _start:
    ; вывод матрицы
    mov ecx, 6
    mov ebx, 0
    LOOP3:
      push ecx
      mov ecx, 6
      LOOP4:
        push ecx
        mov esi, out_buf
        mov ax, [ebx * 2 + matr]
        inc ebx
        cwde
        call IntToStr
        mov edx, eax
        mov eax, 4
        push ebx
        mov ebx, 1
        mov ecx, esi
        int 80h
        pop ebx
        pop ecx
        loop LOOP4
      push ebx
      mov eax, 4
      mov ebx, 1
      mov ecx, new_line
      mov edx, 1
      int 80h
      pop ebx
      pop ecx
      loop LOOP3
    
    ; выход
    mov eax, 1
    xor ebx, ebx
    int 80h

%include "../lib.asm"
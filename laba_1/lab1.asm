    section .data
ExitMsg db "Press Enter to Exit",10
lenExit equ $-ExitMsg
; Добавление переменных A, B для вычисления выражение
; X = A + 5 - B
A dw -30
B dw 21

val1 db 255
chart dw 256
lue3 dw -128
v5 db 10h
db 100101B
beta db 23,23h,0ch
sdk db "Hello",10
min dw -32767
ar dd 12345678h
valar times 5 db 8

val2 dw -25
val3 dd -35
name db "Данил Danil", 0

val4 dw 37
val5 dw 9472

val6 dw 00100101b
val7 dw 0010010100000000b

val8 dw 2500h
val9 dw 0025h

F1 dw 65535
F2 dd 65535

five dw 5, -5

; сегмент не инициализированных переменных
    section .bss
InBuf   resb    10    
lenIn   equ     $-InBuf 
; Зарезервируем место для переменной X
X resd 1
alu resw 10
f1 resb 5

    section .text ; сегмент кода
global _start
_start:
mov EAX,[A] ; загрузить число A в регистр EAX
add EAX,5
sub EAX,[B] ; вычесть число B, результат в EAX
mov [X],EAX ; сохранить результат в памяти
mov EAX, [F1]
add EAX,1
mov EAX, [F2]
add EAX,1
mov AX, [five]
mov ax, [five + 2]
; write
mov     eax, 4          
mov     ebx, 1          
mov     ecx, ExitMsg   
mov     edx, lenExit 
int     80h             
; read
mov     eax, 3       
mov     ebx, 0         
mov     ecx, InBuf     
mov     edx, lenIn    
int     80h           
; exit
mov     eax, 1       
xor     ebx, ebx   
int     80h   

section .data
    ExitMsg db "Press Enter to Exit",10  
   lenExit equ $-ExitMsg
section .bss
    string resb 255
    second_string resb 255
    first_string resb 255
    first resd 1
    second resd 1
    global  _Z13all_substringPcS_ii
    extern _Z9print_strPc
section .text
    _Z13all_substringPcS_ii:
    
      push rbp
      push rdi
      ; Пересчаем параметры в переменные
      mov [second_string], rsi
      mov [first_string], rdi
      mov [first], rdx
      mov [second], rcx

      mov ecx, [second] ; В ecx кладем длину длинной строки
      mov ebx, 0 ; ebx отчевает за длину подстроки
      mov edx, 0

        loop_one:
            lodsb
            pop rdi
            push rdi
            push rcx
            ; провуряем есть есть ли символ вообще в меньшей строке
            mov ecx, [first]
            repne scasb
            pop rcx
            ; если нашли символ то прыгаем на find 
            je find
                cmp ebx, 1
                lea rdi, [string]
                jle smaller ; если длина меньше или равна 1, то прыгаем на smaller
                    ; если длина больше 1, то выводим результат через c++
                    push rax
                    push rcx
                    push rdx
                    push rsi
                    push rdi
                    call _Z9print_strPc
                    pop rdi
                    pop rsi
                    pop rdx
                    pop rcx
                    pop rax
                smaller:
                    mov al, " "
                    push rcx
                    mov ecx, [first]
                    rep stosb
                    pop rcx
                    mov ebx, 0
                    loop loop_one
                    jmp continue
            find:
                mov [ebx + string], al ; кладём в строку новый символ, который точно есть в меньшей строке
                inc ebx

                cmp ebx, 1
                ; если длина больше 1 значит надо искать подстроку в меньшей строке
                ; в противном случае просто возвращаемся на новую итерацию
                jg search_substr
                    loop loop_one
                search_substr:
                    push rdi
                    push rsi
                    push rcx
                    
                    mov rdi, [first_string]
                    lea rsi, [string]

                    mov ecx, [first]
                    sub ecx, ebx
                    add ecx, 1
                    ; цикл проерки подстроки в строке
                    search_cycle:
                        push rdi
                        push rsi
                        push rcx
                        
                        mov ecx, ebx
                        repe cmpsb
                        ; если не совпадает то переходим к следующему
                        ; если нашли то просто возвращаемся к первому циклу, ищем дальше символы
                        jne search_next
                        jecxz search_eaqual
                        ;cmp ecx, 0
                        ;je search_eaqual
                        search_next:
                            pop rcx
                            pop rsi
                            pop rdi
                            inc rdi
                            loop search_cycle
                            jmp search_not_equal
                        search_eaqual:
                            pop rcx
                            pop rsi
                            pop rdi
                            jmp search_finish
                        search_not_equal:
                            ; если мы все таки не нашли, значит надо
                            ; 1. вывести элементы, которые до нового, если длина больше 1
                            ; 2. Новый элемент записать как первый, так как возможно ситуция,
                            ; когда новый элемент будет началом новой подстроки
                            dec ebx
                            push rax
                            push rdi

                            mov al, ' '
                            mov [ebx + string], al

                            cmp ebx, 1
                            lea rdi, [string]
                            jle search_smaller 
                                ; если длина меньше или равна 1, то прыгаем на smaller
                                ; если длина больше 1, то выводим результат через c++
                                push rax
                                push rcx
                                push rdx
                                push rsi
                                push rdi
                                call _Z9print_strPc
                                pop rdi
                                pop rsi
                                pop rdx
                                pop rcx
                                pop rax
                            search_smaller:
                                mov al, " "
                                push rcx
                                mov ecx, [first]
                                rep stosb
                                pop rcx
                                mov ebx, 1
                                pop rdi
                                pop rax
                                mov [string], al
                                
                search_finish:
                    pop rcx
                    pop rsi
                    pop rdi
                    dec ecx
                    jnz loop_one
            continue:

            cmp ebx, 1
            lea edi, [string]
            jle smaller_two ; если длина меньше или равна 1, то прыгаем на smaller
                    ; если длина больше 1, то выводим результат через c++
               push rax
               push rcx
               push rdx
               push rsi
               push rdi
               call _Z9print_strPc
               pop rdi
               pop rsi
               pop rdx
               pop rcx
               pop rax
            smaller_two:
               pop rdi
               pop rbp
               ret
%include "../lib64.asm"


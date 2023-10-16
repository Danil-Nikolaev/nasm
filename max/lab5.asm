

section .data; сегмент инициализированных переменных
	Space db ' ' 
	NewLine: db 0xA
	
	InputMsg db "Input string: ", 0xA ; выводимое сообщение
	lenInput equ $-InputMsg
	
	InputLetMsg db "Input combination of letters: ", 0xA ; выводимое сообщение
	lenInputLet equ $-InputLetMsg
	
	LettersNumberMsg db "Number of letters:" ; номера букв в слове, которые совпали с сочетанием
	lenLettersNumber equ $-LettersNumberMsg
	
	WordNumberMsg db "; Number of word:" ; номера слова с сочетанием
	lenWordNumber equ $-WordNumberMsg

; сегмент неинициализированных переменных
section .bss
	input_str resb 256
	; str_len equ $- input_str-1
	str_len resq 1
	
	input_let resb 23
	; let_len equ $- input_let-1
	let_len resq 1
	
	OutBuf resb 2 ; буфер для выводимой строки
	lenOut equ $-OutBuf
			
section .text ; сегмент кода
global _Z22combination_of_lettersPcS_ii
extern _Z5printPc

_Z22combination_of_lettersPcS_ii:
; часть кода, которая будет на плюсах

	push rbp

	mov [input_str], rdi
	mov [str_len], rdx 
	mov [input_let], rsi
	mov [let_len], rcx 
	mov rdx, rcx
	
	mov rdi, [input_str] ; введенная строка
	mov rsi, [input_let] ; ввденное сочетание
	; mov rdx, let_len ; длина сочетания
	
; часть кода, которая будет на ассемблере
	mov r10, rsi
	mov r12, rdx
	mov rsi, rdi
	; расчеты
	mov rcx, [str_len] ; длина строки
	mov r9, 1 ; номер слова в строке
	mov r8, 0 ; номер буквы в слове
	
	cycle1:
		push rcx ; сохраняем счетчик
		
		; проверка на конец строки
		mov al, [r10]
		mov bl, al
		
		mov al, [rsi]
		cmp al, 0xA
		je done
		
		; проверка на пробел (конец слова)
		cmp al, ' '
		je new_word
		
		inc r8 ; увеличиваем номер символа в слове
		
		; проверка на совпадение данного символа с первой буквой сочетания
		cmp al, bl
		jne next_letter
		
		mov r14, 0
		
		mov rcx, r12 ; счетчик по буквам сочетания
		cycle2:
			inc r14 ; увеличиваем шаг по символам
			
			; проверка на совпадение остальных букв сочетания с соседями найденной
			inc r10
			mov al, [r10]
			mov bl, al
			
			inc rsi
			mov al, [rsi]
			cmp al, bl
			jne next_step ; выход из цикла

			loop cycle2 ; конец проверки совпадения остальных символов
		
		next_step:
		sub rsi, r14
		sub r10, r14
		
		mov r13, rsi
		mov r15, r10
		pop rcx
		
		; совпали ли все символы сочетания?
		cmp r12, r14 ; длина сочетания и кол-во совпавших букв
		jne next_letter
		
		; цикл по дабавлению в матрицу номеров букв, совпавших с сочетанием
		call PrintLettersNumber
		call PrintSpace
		
		mov rcx, r14
		cycle3: ; вывод номером букв
			push rcx ; сохраняем счетчик
			mov rax, r8
			mov rsi, OutBuf
			call IntToStr64
			call PrintNumber
			call PrintSpace

			inc r8
			pop rcx
			loop cycle3 ; конец добавления 
		
		pop rcx
		; добавление номера слова
		call PrintWordNumber
		call PrintSpace
		
		mov rax, r9
		mov rsi, OutBuf
		call IntToStr64
		call PrintNumber
		call PrintNewLine
		
		mov rsi, r13
		mov r10, r15
		
		next_letter:

		inc rsi
		dec rcx
		jnz cycle1 ; конец прохода по строке	
	
	new_word:
		pop rcx
		mov r8, 0
		inc r9
		jmp next_letter
	
	; вывод результата
	done:
	
	exit:
		mov rax, 60; системная функция 60 (exit)
		xor rdi, rdi; return code 0
		syscall; вызов системной функции
		
	PrintInputMsg:
		mov rax, 1
		mov rdi, 1
		mov rsi, InputMsg
		mov rdx, lenInput
		syscall
		ret
		
	PrintInputLetMsg:
		mov rax, 1
		mov rdi, 1
		mov rsi, InputLetMsg
		mov rdx, lenInputLet
		syscall
		ret
		
	PrintWordNumber:
		mov rax, 1
		mov rdi, 1
		mov rsi, WordNumberMsg
		mov rdx, lenWordNumber
		syscall
		ret
		
	PrintLettersNumber:
		mov rax, 1
		mov rdi, 1
		mov rsi, LettersNumberMsg
		mov rdx, lenLettersNumber
		syscall
		ret
		
	PrintNumber:
		mov rax, 1
		mov rdi, 1
		mov rsi, OutBuf
		mov rdx, lenOut
		syscall
		ret
		
	PrintSpace:
		mov rax, 1
		mov rdi, 1
		mov rsi, Space
		mov rdx, 1
		syscall
		ret
		
	PrintNewLine:
		mov rax, 1
		mov rdi, 1
		mov rsi, NewLine
		mov rdx, 1
		syscall
		ret
%include "../lib64.asm"
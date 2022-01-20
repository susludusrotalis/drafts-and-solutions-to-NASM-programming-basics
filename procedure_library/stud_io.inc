;; File stud_io.inc for Linux O.S.
;; Copyright (c) Andrey Vikt. Stolyarov, 2009.
;; I, the author, hereby grant everyone the right to use this
;; file for any purpose, in any manner, in it's original or
;; modified form, provided that any modified versions are
;; clearly marked as such.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; system dependend part

; generic 3-param syscall
%macro _syscall_3 4
	push edx
	push ecx
	push ebx ; it is senseless to save eax as it holds the return
	push %1
	push %2
	push %3
	push %4
	pop edx
	pop ecx
	pop ebx
	pop eax
	int 0x80
	pop ebx
	pop ecx
	pop edx
%endmacro

; syscall_exit is the only syscall we use that has 1 parameter
%macro _syscall_exit 1
	mov ebx, %1	; exit code
	mov eax, 1	; 1 = sys_exit
	int 0x80
%endmacro

;; system dependent part ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; %1: descriptor   %2: buffer addr   %3: buffer length
; output: eax: read bytes
%macro _syscall_read 3
	_syscall_3 3,%1,%2,%3
%endmacro

; %1: descriptor   %2: buffer addr   %3: buffer length
; output: eax: written bytes
%macro _syscall_write 3
	_syscall_3 4,%1,%2,%3
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro 	PRINT 1
	pusha
	pushf
	jmp %%astr
%%str	db	%1, 0
%%strln	equ	$-%%str
%%astr:	_syscall_write 1, %%str, %%strln
	popf
	popa
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro	PUTCHAR 1
	pusha
	pushf
%ifstr %1
	mov	al, %1
%elifnum %1
	mov	al, %1
%elifidni %1,al
	nop
%elifidni %1,ah
	mov	al, ah
%elifidni %1,bl
	mov	al, bl
%elifidni %1,bh
	mov	al, bh
%elifidni %1,cl
	mov	al, cl
%elifidni %1,ch
	mov	al, ch
%elifidni %1,dl
	mov	al, dl
%elifidni %1,dh
	mov	al, dh
%else
	mov	al, %1  ; let's hope it is a memory location such as [var]
%endif
	sub	esp, 2  ; reserve memory for buffer
	mov	edi, esp
	mov	[edi], al
	_syscall_write 1, edi, 1
	add	esp, 2
	popf
	popa
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro	GETCHAR 0
	pushf
	push	edi
	sub	esp, 2
	mov	edi, esp
	_syscall_read 0, edi, 1
	cmp	eax, 1
	jne	%%eof_reached
	xor	eax,eax
	mov	al, [edi]
	jmp	%%gcquit
%%eof_reached:
	xor	eax, eax
	not	eax 		; eax := -1
%%gcquit:
	add	esp, 2
	pop	edi
	popf
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro PRINT_UNSIGNED_INT 1
    section .bss
    %%digits resb 10
    section .data
    %%newline_char db `\n`
    section .text
    %%unsigned_to_string:
        ;Prining unsigned_int by dividing by const 10
        push    eax
        mov     eax, %1
        cdq                           ;expands eax to eax:edx
        
        mov     ebx, 10               ;CONST
        xor     ecx, ecx              ;Reset counter of digits in number

    %%.div_10: 
        ;Setup for division DX:AX / BX
        div     ebx                   ; -> AX is Quotient, Remainder DX=[0,9]
        add     edx, "0"              ;Turn into character [0,9] -> ["0","9"]
        push    edx                   ;(1) Save remainder for now
        inc     ecx                   ;One more digit
        xor     edx, edx
        test    eax, eax              ;Is quotient zero?
        jnz     %%.div_10             ;No, use as next dividend
        
        mov     ebx, ecx              ;store ecx
        xor     eax, eax              ;set eax as counter
        
    %%.load_to_mem:
        pop     edx
        mov     [%%digits + eax], dl
        inc     eax   
        loop    %%.load_to_mem
        
        mov     byte [%%digits + eax], `\n`
        mov     ecx, ebx              ;restore ecx
        inc     ecx
        
    %%.print:
        mov     edx, ecx              ;number length
        mov     ecx, %%digits         ;points to stack
        mov     ebx, 1                ;file descriptor (stdout)
        mov     eax, 4                ;system call number (sys_write)
        int     80h		      ;call kernel 
        pop     eax
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro        KERNEL 1-*
; performs system call with arguments stored in stack
;(takes maximum of 6 args due to linux limitations on maximum number of args)
%if  %0 > 1                                 ;registers will be spoiled
                    push ebx
    %if %0 > 4
                    push esi
                    push edi
                    push ebp
    %endif
%endif
%rep %0                                     ;load macro args to stack
    %rotate -1
                    push dword %1
%endrep                                     ;load args to registers
                    pop eax
%if %0 > 1
                    pop ebx
    %if %0 > 2  
                    pop ecx
        %if %0 > 3
                    pop edx
            %if %0 > 4
                    pop esi
                %if %0 > 5
                    pop edi
                    %if %0 > 6
                    pop ebp
                        %if %0 > 7
                            %error "Can`t do Linux syscall with 7+ params"
                        %endif
                    %endif
                %endif
            %endif
        %endif
    %endif
%endif
                    int 80h
                    mov ecx, eax                ;if an error occured load its
                    and ecx, 0fffff000h         ;code to ecx, otherwise ecx is 0
                    cmp ecx, 0fffff000h     
                    jne %%ok
                    mov ecx, eax
                    neg ecx
                    mov eax, -1
                    jmp short %%q
%%ok:               xor ecx, ecx
%%q:
%if %0 > 1
    %if %0 > 4
                    pop ebp
                    pop edi
                    pop esi
    %endif
                    pop ebx
%endif
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro FINISH 0-1 0
	_syscall_exit %1
%endmacro


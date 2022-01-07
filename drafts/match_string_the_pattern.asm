%include "stud_io.inc"


section .data
;string and patter musts end with 0!
string db "abc", 0
pattern db "****a**?**c***", 0
section .text
global _start

_start:
;pass arguments to subprogram, then clear stack
    push dword pattern              
    push dword string
    call match
    add esp, 8

;print the result
    cmp eax, 0
    jz doesnt_match
    PRINT "String matches pattern"
    jmp quit
doesnt_match:
    PRINT "String doesn`t match pattern"
quit:
    PRINT `\n`
    FINISH
    
match:
;first, initialize stack frame
    push ebp                    
    mov ebp, esp
    sub esp, 4                  ;local variable stored at [ebp - 4]
    
    push esi                    ;save register and 
    push edi                    ;restore them late (required by cdecl)
    
;load arguments to registers
    mov esi, [ebp + 8]          ;string address
    mov edi, [ebp + 12]          ;pattern address
    
;each iteration trims string and pattern 
;and return eax=1 if string matches pattern
;or eax=0 if not
.func_loop:
    
    
    cmp byte [edi], 0           ;pattern ended?
    jne .not_end                ;   if not jump not_end     
    cmp byte [esi], 0           ;string ended? 
    jne .false                  ;   if not return false
    jmp .true                   ;if string and pattern ended simultaneously
                                ;then they match
.not_end:
    cmp byte [edi], "*"         ;pattern starts with "*"?
    jne .not_star               ;   if not jump not_end
                                ;if so start loop (nested inside subprogram loop)
    mov dword [ebp-4], 0        ;variable I := 0

;nested loop that executes when "*" appears
.star_loop:
    ;attempt recursive call
    mov eax, edi                ;load second arg to stack, which is trimmed pattern
    inc eax                     ;trim by 1 char
    push eax
    mov eax, esi                ;load fisrt arg which is trimmed string
    add eax, [ebp-4]            ;trim it by I chars, note that [ebp-4] is variable I
    push eax     
    call match                  ;attempt recursive call with given arguments
    
    ;get back after recursive call
    add esp, 8                  ;clear stack              
    test eax, eax               ;does trimmed sting match trimmed pattern?
    jnz .true                   ;   if so return True
    add eax, [ebp-4]            ;else trim string once again
    
    cmp byte [esi+eax], 0       ;but what if string ended?
    je  .false                  ;   then return False
    inc dword [ebp-4]           ;else trim string by one char (I := I + 1)
    jmp .star_loop              ;and continue nested loop
    
;jmp here if string is not empty and doesn`t start with "*"
.not_star:
    mov al, [edi]               ;string starts with '?' ?         
    cmp al, '?'                 ;   if so jump question_mark
    je .question_mark   
    cmp al, [esi]               ;if not check if first char of string matches first char of pattern
    jne .false                  ;   if not return False
    jmp .continue               ;if so continue subprogram

;jmp here if string starts with '?'
.question_mark:
    cmp byte [esi], 0           ;check if string ended
    jz .false                   ;   if so return False
    
;continue func_loop
.continue:
    inc esi
    inc edi
    jmp .func_loop
    
;return True (eax=1)
.true:
    mov eax, 1
    jmp .quit
;return False (eax=0)
.false:
    xor eax, eax
;restore registers, return control to calling function
.quit:
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
   
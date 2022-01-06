%include "stud_io.inc"

global _start

section .text
;reverse string that ends with 0
_start:

;print initial string
print_initial:
    mov	edx, 8		        ;string length
    mov	ecx, string         
    mov	ebx, 1		        ;file descriptor (stdout)
    mov	eax, 4		        ;system call number (sys_write)
    int	0x80		        ;call kernel
    PRINT `\n`
init_loop:
    ;
    xor ebx, ebx                ;bl is gonna store each next char of the string
    xor ecx, ecx                ;char idx
    mov esi, string             ;string addr
;push string to stack
lp:
    mov bl, [esi+ecx]           ;get char from string
    cmp bl, 0                   ;current char is 0?
    je lpquit                   ;if so quit loop
    push ebx                    ;push current char to stack (note that only first byte stores char)
    inc ecx                     ;increment char idx
    jmp lp                      ;continue loop   
lpquit:
    jecxz done                  ;string is empty? then quit 
    mov edi, esi                ;string addr (this time as a destination idx)
    
;pop string from stack
lp2:
    pop ebx                     ;pop char
    mov [edi], bl               ;write it to string starting from idx=0 (note that only bl stores char)
    inc edi                     ;char addr
    loop lp2                    ;continue loop until ecx=0 (ecx equals string length at the start of the loop)

;print resulting string
print_result:
    mov	edx, 8		        ;string length
    mov	ecx, string         
    mov	ebx, 1		        ;file descriptor (stdout)
    mov	eax, 4		        ;system call number (sys_write)
    int	0x80		        ;call kernel  
    PRINT `\n`
done:
    FINISH
    
section .data
string db "abcdefg0"

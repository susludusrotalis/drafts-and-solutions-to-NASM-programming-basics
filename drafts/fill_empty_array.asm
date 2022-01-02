section .text
    global _start
    
_start:
    mov ecx, 256            ;array length
    mov edi, array          ;write array addres to edi
    mov al, '*'             ;write ascii code of "*" to al (first byte of eax)
    
again:
    mov [edi], al           ;write "*" to array which address is stored in edi
    inc edi                 ;increment address 
    dec ecx                 ;decrement loop counter
    jnz again               ;check if ZF is set to 1 (zero flag will be set to 1 in case if the result of previous operation is 0, 
                            ;in other word when loop counter ecx is zero)
print_empty_array:  
    ;specify args for system call
    mov	edx, 256     	  ;array length
    mov	ecx, array         ;array address
    mov	ebx, 1		  ;file descriptor (1 corresponds to stdout)
    mov	eax, 4		  ;system call number (4 corresponds to sys_write)
    ;call kernel
    int  80h		 
    
newline:
    ;specify args for system call
    mov	edx, 1     	  ;message length
    mov	ecx, newline_char  ;newline character as output
    mov	ebx, 1		  ;file descriptor (1 corresponds to stdout)
    mov	eax, 4		  ;system call number (4 corresponds to sys_write)
    ;call kernel
    int  80h		  ;call kernel
    
exit:
    mov	eax, 1		  ;system call number (1 corresponds to sys_exit)
    int 80h         	  ;call kernel

section .data
newline_char db 0x0a
section .bss
array resb 256
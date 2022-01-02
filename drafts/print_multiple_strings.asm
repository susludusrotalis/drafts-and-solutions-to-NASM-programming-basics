section .text
   global _start           
	
_start:  
    mov ecx, 3             ;set loop counter
    ; write string content to corresponding variable
    mov [string], byte 0x28
    mov [string + 1], byte 0x2E
    mov [string + 2], byte 0x29
    mov [string + 3], byte 0x28
    mov [string + 4], byte 0x2E
    mov [string + 5], byte 0x29
    mov [string + 6], byte 0x0a
_print_string:
    push ecx               ;push loop counter to stack
    mov	edx, 7     	  ;message length
    mov	ecx, string        ;message to write
    mov	ebx, 1		  ;file descriptor (1 corresponds to stdout)
    mov	eax, 4		  ;system call number (4 corresponds to sys_write)
    int  80h		  ;call kernel
    pop ecx                ;pop loop counter from stack
    loop _print_string
    
_continue:
    mov	eax, 1		  ;system call number (1 corresponds to sys_exit)
    int 80h         	  ;call kernel
section .bss
string resb 7
            
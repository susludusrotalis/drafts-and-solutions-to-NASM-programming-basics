section .text
    global _start

_start: 
; add numbers with carry, first number is in eax and ebx and second is in ecx and edx
    mov eax, 0000_0000_0001_0001b   ;eax stores first 32 bits of number_1
    mov ebx, 0101_1010_1110_1111b   ;ebx stores second 32 bits of number_1
    mov ecx, 0000_0010_0010_0110b   ;ecx stores first 32 bits of number_2
    mov edx, 0101_0101_0110_1111b   ;edx stores second 32 bits of number_2
    add ebx, edx                    ;add first 32 bits of number_1 and first 32 bits of number_2
    adc eax, ecx                    ;add second 32 bits of number_2 and second 32 bits of number_2 considering CF (carry) flag

    mov	eax, 1		          ;system call number (sys_exit)
    int	0x80		          ;call kernel
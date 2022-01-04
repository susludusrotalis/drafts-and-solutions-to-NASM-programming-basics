%include "stud_io.inc"

section .text
   global _start

_start:
    mov ax, 256     ;dividend
    mov cx, 2       ;divisor
    ;implementation of while loop
    PRINT `compare AX to 0 \n`
loop:
    ;check if EAX = 0, if not exit loop
    cmp ax, 0    
    je loop_quit                                    
    div cx                     ;divide AX by 2
    PRINT `iteration \n`
    jmp loop                    
loop_quit:    
    PRINT `finish loop \n`
    FINISH           
                                      
    
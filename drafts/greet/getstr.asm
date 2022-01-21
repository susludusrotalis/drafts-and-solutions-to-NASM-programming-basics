;; asmgreet/getstr.asm ;;
%include "stud_io.inc"
global getstr

section .text
global getstr
getstr:
        push ebp
        mov ebp, esp                    
        mov edx, [ebp+8]                ;arg1 - buf address, store it in edx
        xor ecx, ecx                    ;ecx is char counter
.again:
        inc ecx
        cmp ecx, [ebp+12]               ;arg2 - buf length
        jae .quit
        push ecx                        ;reigsters may be spoiled, stroe them in stack
        push edx
        KERNEL 3, 0, edx, 1            ;read string by one character at a time
        pop edx
        pop ecx
        cmp eax, 1                      ;if syscall failed eax is -1
        jne .quit
        mov al, [edx]
        cmp al, 10
        je .quit
        inc edx
        jmp .again
.quit   mov [edx], byte 0               ;add terminating null to the end of the string
        mov esp, ebp
        pop ebp
        ret
        
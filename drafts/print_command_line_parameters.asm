section .text
global _start

nlstr       db      10, 0

strlen:          ;arg1 = address of the string
        push ebp
        mov ebp, esp
        xor eax, eax
        mov ecx, [ebp+8]    ;arg1
.lp:    cmp byte [eax+ecx], 0
        jz .quit
        inc eax
        jmp short .lp
.quit:  pop ebp
        ret
        
print_str:      ;arg1 == address of the string
        push ebp
        mov ebp, esp
        push ebx            ;will be spoiled
        mov ebx, [ebp+8]    ;arg1
        push ebx            ;   (address of the string as a parameter for strlen)
        call strlen
        add esp, 4          ;the length is now in eax
        
        mov edx, eax        ;edx now contains the length
        mov ecx, ebx        ;arg1; was stored in ebx
        mov ebx, 1          ;stdout
        mov eax, 4          ;write
        int 80h
        
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
_start:
        mov ebx, [esp]      ;argc
        mov esi, esp        
        add esi, 4          ;argv
again:  push dword [esi]    ;argv[i] (as a parameter for print_str)
        call print_str
        add esp, 4
        push dword nlstr
        call print_str
        add esp, 4
        add esi, 4
        dec ebx 
        jnz again
        
        mov ebx, 0          ;no errors occurred
        mov eax, 1          ;_exit
        int 80h
        
        
        
        
        
        
        
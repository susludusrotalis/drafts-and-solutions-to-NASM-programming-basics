;; asmgreet/pusstr.asm ;;
%include "stud_io.inc"              ;include header containing KERNEL macro
global putstr                       ;this module describes putstr procedure
extern strlen                       ;and uses strlen procedure

section .text
; procedure putstr
; [ebp+8] = address of the string
putstr:
        push ebp
        mov ebp, esp
        push dword [ebp+8]          ;call streln
        call strlen
        add esp, 4                  ;result is now in eax
        KERNEL 4, 1, [ebp+8], eax   ;print string
        mov esp, ebp
        pop ebp
        ret
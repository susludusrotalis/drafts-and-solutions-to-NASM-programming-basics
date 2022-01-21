;; asmgreet/greet.asm ;;
global  _start              ;main module uses following procedures
extern  putstr
extern  getstr
extern  quit

section .data                   ;welcome message
nmq     db      "Hi, what is your name?", 10, 0
pmy     db      "It`s pleasure to meet you, ", 0
exc     db      "!", 10, 0

section .bss
buf     resb    512             ;initialize buffer
buflen  equ     $-buf

section .text
global _start
_start:
        push    dword nmq          ;
        call    putstr             ;print out nmq
        add     esp, 4
        
        push    dword buflen
        push    dword buf
        call    getstr             ;get string from stdin
        add     esp, 8
        
        push    dword pmy
        call    putstr              ;print out pmy
        add     esp, 4
        
        push    dword buf
        call    putstr             ;print out input string
        add     esp, 4
        
        push    dword exc          
        call    putstr              ;print exc string
        add     esp, 4
        call    quit                ;call quit
    
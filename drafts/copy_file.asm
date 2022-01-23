%include "stud_io.inc"

global _start

section .text
_start: 
openwr_flags    equ 241h                    ;open for writing; allow creation of new one; trunc if exists
        pop dword [argc]                    ;number of arguments
        mov [argvp], esp                    ;address of the args array 
        cmp dword [argc], 3                 ;command line arguments contain: program name, name of src file, name of dest file
        je .args_count_ok
        KERNEL  4, 2, helpmsg, helplen      ;print error helpmsg in case if wrong number of args passed
        KERNEL  1, 1
.args_count_ok:
        mov esi, [argvp]
        mov edi, [esi+4]                    ;name of src file
        KERNEL 5, edi, 0                    ;O_RDONLY
        cmp eax, -1                         ;macro returns -1 as a error message
        jne .source_open_ok
        KERNEL 4, 2, err1msg, err1len
        KERNEL 1, 2
.source_open_ok:
        mov [fdsrc], eax                    ;descriptor of src file
        mov esi, [argvp]
        mov edi, [esi + 8]                  ;name of dest file
        KERNEL 5, edi, openwr_flags
        cmp eax, -1
        jne .dest_open_ok
        KERNEL 4, 2, err2msg, err2len
        KERNEL 1, 3
.dest_open_ok:
        mov [fddest], eax                   ;dest file descriptor
.again: 
        KERNEL 3, [fdsrc], buffer, bufsize  ;write chunk of 4096 bytes to buffer
        ;KERNEL 4, 1, here, herelen
        cmp eax, 0
        jle .end_of_file                    ;eax = 0 if EOF, eax < 0 if error occured
        KERNEL 4, [fddest], buffer, eax
;        KERNEL 4, 1, buffer, eax
        ;KERNEL 4, 1, here, herelen
        jmp .again
.end_of_file:
        KERNEL 6, [fdsrc]
        KERNEL 6, [fddest]
        KERNEL 1, 0 
        

section .data
;error messages
here        db "Here"
herelen     equ $-here
helpmsg     db  'Usage: copy <src> <dest>', 10
helplen     equ $-helpmsg
err1msg     db  "Couldn`t open source file for reading", 10
err1len     equ $-err1msg
err2msg     db "Couldn`t open destination file for writing", 10
err2len     equ $-err2msg

  
section .bss 
buffer      resb    4096                    ;stores file chunk of 4096 bytes
bufsize     equ     $-buffer                    
fdsrc       resd    1                       ;src file descriptor
fddest      resd    1                       ;destination file descriptor
argc        resd    1                       ;number of command line args
argvp       resd    1                       ;ptr to command line args





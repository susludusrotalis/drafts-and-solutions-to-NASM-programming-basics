%include "stud_io.inc"

global _start
        
section .text
global _start

_start:
    ;print initial string
    mov	edx, 17		           ;string length
    mov	ecx, initial_string         
    mov	ebx, 1		           ;file descriptor (stdout)
    mov	eax, 4		           ;system call number (sys_write)
    int	0x80		           ;call kernel
    
    ;insert the word 'long' in the middle of the string
    std                             ;set direction of copying from right to left
    mov edi, initial_string+16+5    ;address to the address of the last byte plus length of string we attempt to insert
    mov esi, initial_string+16      ;address of the last byte    
    mov ecx, 7                      ;length of the last word (including newline char)
    rep movsb                       ;move the last 7 bytes to the right
    mov esi, string_to_insert+4     ;address of string we want to insert
    mov ecx, 5                      ;length of this string
    rep movsb                       ;insert it to the initial string in the place where the last word was before;
    ;PRINT "here"
    
    ;print string after insertion
    mov	edx, 17+5		   ;string length
    mov	ecx, initial_string 
    mov	ebx, 1		           ;file descriptor (stdout)
    mov	eax, 4		           ;system call number (sys_write)
    int	0x80		           ;call kernel
    
    mov	eax, 1		           ;system call number (sys_exit)
    int	0x80		           ;call kernel
    
section .data
string_to_insert db "long "
initial_string db `This is a string\n`
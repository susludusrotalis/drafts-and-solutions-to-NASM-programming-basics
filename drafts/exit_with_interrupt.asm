%include "stud_io.inc"

global      _start

section .text
;There are approximately 250 services provided by this interrupt (80h). 
;The service number is put in EAX and then the other parameters are put in the remaining microprocessor registers: 
;EBX, ECX, EDX, ESI, EDI and EBP.
;
;Service 1 : exit the current process and return to the system that invoked it. 
;In EBX the output mode is set, generally we put 0 to indicate that the output occurred normally (that is, it was not caused by an error).

_start:     
            PRINT "Hello there!"
            mov eax, 1
            mov ebx, 0
            int 80h 

            
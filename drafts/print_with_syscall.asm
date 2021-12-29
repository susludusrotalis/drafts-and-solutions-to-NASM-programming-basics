section .text
   global _start           
	
_start:                    
   mov	edx, 1		  ;message length
   mov	ecx, message       ;message to write
   mov	ebx, 1		  ;file descriptor (1 corresponds to stdout)
   mov	eax, 4		  ;system call number (4 corresponds to sys_write)
   int	0x80		  ;call kernel

   mov	eax, 1		  ;system call number (sys_exit)
   int	0x80		  ;call kernel

section .data
message DB 'y'
            
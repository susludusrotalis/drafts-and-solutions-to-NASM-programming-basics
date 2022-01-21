;; asmgreet/quit.asm ;;
%include "stud_io.inc"
global quit
section .text
quit:
    KERNEL 1, 0
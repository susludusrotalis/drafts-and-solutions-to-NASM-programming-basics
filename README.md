# drafts-and-solutions-to-NASM-programming-basics
My drafts and solutions to exercises from Andrey Stolyarov`s book "Programming basics", namely to the chapter that refers to assembly language programming. All of the programs are written in NASM and can be compiled into 32-bit ELF and linked using following commands:
```
nasm -f elf32 -o <filename>.o <filename>.asm
ld -m elf_i386 -o <filename> <filename>.o
```
Note that some of the programs include source file "stud_io.inc", and since include files are searched in the directory you are in when you run NASM plus any directories specified on the NASM command line using -i command, as oposed to the location of the NASM executable or the location of the source file, you need to either hardcode its file path like this:
```
%include “/home/user/asm-drafts/procedure_library/stud_io.inc”
```
or to to specify any additionally referenced directories on the NASM command line, using the -i option:
```
nasm -i /home/user/asm-drafts/procedure_library/ -f elf32 -g -F dwarf example1.asm
```

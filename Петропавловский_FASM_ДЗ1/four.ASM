format PE console

entry start

include 'win32a.inc'

section '.code' code executable
    start:
        ; mov ecx, 110b
        ; shl ecx, 1
         push A
         push space
         call [scanf]

         mov ecx, [A]
         shl ecx, 1
         push ecx
         push resStr
         call [printf]


         call [getch]
         push NULL
         call [ExitProcess]

section '.data' data readable writable
    resStr db 'REsult: %d', 0
       strr db '---', 0
    space db ' %d', 0
    A dd ?
    NULL = 0

section '.idata' import data readable
    library kernel, 'kernel32.dll', \
             msvcrt,   'msvcrt.dll'
    import kernel,\
           ExitProcess, 'ExitProcess'
    import msvcrt,\
           printf, 'printf',\
           getch,'_getch',\
           scanf, 'scanf'
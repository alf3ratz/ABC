format PE console

entry start

include 'win32a.inc'

section '.code' code executable
    start:
         mov ecx, 1001b
         or ecx, 1011b
         push ecx
         push Rstr
         call [printf]
         mov eax, 1000b
         and eax, 1101b
         push eax
         push Rstr

         call [printf]
          mov eax, 0001b
         xor eax, 1100b
         push eax
         push Rstr

         call [printf]
         call [getch]
         push NULL
         call [ExitProcess]

section '.data' data readable writable
    Rstr db 'Result: %d  ', 0
    space db ' %d', 0
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
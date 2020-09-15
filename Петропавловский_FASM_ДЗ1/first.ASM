format PE console
entry start
include 'win32a.inc'
section '.code' code executable
start:
    push hello
    call [printf]
    push 0
    call   [getch]
    call [ExitProcess] 
section '.data' data readable
    hello db 'Hello World!', 0 
section '.idata' import data readable
    library kernel, 'kernel32.dll', \
             msvcrt,   'msvcrt.dll'
    import kernel,\
           ExitProcess, 'ExitProcess'
    import msvcrt,\
           printf, 'printf',\
           getch,'_getch'
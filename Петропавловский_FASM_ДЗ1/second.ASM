        format PE console

        entry start

        include 'win32a.inc'

        section '.code' code executable
           start:
                push strA
                call [printf]

                 push A
                 push spaceStr
                 call [scanf]

                push strB
                call [printf]

                 push B
                  push spaceStr
                  call [scanf]

                push strOp
                call [printf]
               mov ecx, [A]
               add ecx, [B]
               push ecx
                push result
                call [printf]
            call   [getch]
            push NULL
            call [ExitProcess]
        section '.data' data readable  writable
                strA db 'Enter first num: ',0
                strB db 'Enter second num: ', 0
                result db 'REsult: %d', 0
                spaceStr db ' %d', 0
                strOp db 'Operation: ', 0
                A dd ?
                B dd ?
               NULL =0
        section '.idata' import data readable
           library kernel, 'kernel32.dll', \
                  msvcrt,   'msvcrt.dll'
                  import kernel,\
           ExitProcess, 'ExitProcess'
           import msvcrt,\
                  printf, 'printf',\
                  getch,'_getch',\
                  scanf, 'scanf'
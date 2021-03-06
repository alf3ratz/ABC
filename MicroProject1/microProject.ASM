
;----------------------------------------��������������� ������ ���198----------------------------------------
;------------------------------------------------������� 24---------------------------------------------------
;                                              ����� �������:
;����������� ���������, ������������ ����� ������� ����� ��������� � ��������� �� 1 �� ��������� �����


format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
ru db 'Russian',0
i dd 0
f1 dd ?
f2 dd ?
d dd ?
temp dd  ?
num dd ?
probel db ' ',13,10,0
info db '����� ������� ����� ��������� � ��������� �� 1 �� ��������� �����: ',13,10,0
showTwoNums db '������ �������� ����������������� : %d -- %d (��� ����� �������) ',13,10,0
showNum db '> prime num: %d ',13,10,0
probell db '(%d)  ',13,10, 0                            ;�.�. �� 65535
endd db '~~~����� ���������~~~',13,10,0

section '.code' code readable executable
start:
cinvoke setlocale,0,ru
call searchFibo
push 0
call [getch]
call [ExitProcess]

proc searchFibo
    invoke printf, info
    add esp, 4
    mov [f1],1
    mov [f2], 2
    mov ecx, [f1]
    mov edx, [f2]
    push [f2]       ;����� ������� ���������
    push [f1]
    push showTwoNums
    call [printf]
    add esp, 12
    mov ebx, 0
    mov eax, 0

    loopFiba:

        mov ecx, dword[f1]
        mov edx, dword[f2]
        xor ebx, ebx
        add ebx,ecx
        add ebx,edx     ;����� �������������� � ���������� ����� -> ��������� ����� ������������������
        mov [num], ebx

        mov [d], 1
          forEach:
                 xor ecx,ecx
                 xor edx,edx
                 inc [d]
                 mov eax, dword[num]
                 mov ebx, dword[d]
                 div ebx              ;ForeEach ��� �������� ����� �� ��������
                 cmp edx, 0
                 jne forEach
                 cmp ebx, dword[num]
                 je continuePrime
                 cmp ebx, dword[num]
                 jne continue

                     continuePrime:       ;����� ��� ���������� ���� ��������� ��������,
                                          ;���� ��������� ����� ������������������ ������� + ����� ����� �����
                         mov ecx,dword[f1]
                         mov edx, dword[f2]
                         mov [temp],edx
                         mov ecx,edx         ;f1=f2
                         mov edx,dword[num]  ;f2 = num = (f1+f2)(��������� � ������ ����� loopFiba)
                         mov [f1], ecx
                         mov [f2], edx      ;���������� ���������� � �������������� �����
                         inc [i]

                         push [num]
                         push showNum
                         call [printf]
                         add esp, 8
                         cmp [i], 24
                         jne loopFiba
                         cmp [i], 24
                         je finish

                     continue:            ;����� ��� ���������� ���� ��������� ��������,
                                          ;���� ��������� ����� ������������������ ���������

                         mov ecx,dword[f1]    ;b=f1
                         mov edx, dword[f2]
                         mov [temp],edx

                         mov ecx,edx           ;f1=f2
                         mov edx,dword[num]    ;f2 = num = (f1+f2)(��������� � ������ ����� loopFiba)
                         mov [f1], ecx
                         mov [f2], edx        ;���������� ���������� � �������������� �����
                         inc [i]
                         mov eax, [i]
                         cmp [i], 24
                         jne loopFiba    ;���������� ���-�� ����� ���������, �.�. 25 ����� ������������������ > ��������� �����.
                         cmp [i], 24                        ; �.�. 75025 > 65535
                         je finish

        finish:
              push endd
              call [printf]   ;���������� ���������
              add esp, 4
              ret
endp

section  '.idata' import data readable
library kernel,'kernel32.dll',\
        msvcrt, 'msvcrt.dll'
import kernel,\
        ExitProcess,'ExitProcess' ;������������� ����������
import msvcrt,\
        setlocale, 'setlocale',\
        printf, 'printf',\
        system,'system',\
        getch, '_getch'
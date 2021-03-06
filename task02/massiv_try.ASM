

;------------------������� �4------------------
;����������� ���������, ������������ ������������ ��������� ������ ��� ������,
;������� ������ ���������� ������ A[N], ��������� �� ��������� �������  � ����� ������ � �� ��������:
;������� �������� �4: ������� �[i] = 1, ���� A[i]>0
;                             �[i]= -1, ���� A[i]<0
;                             �[i]=0, ���� A[i]=0

format PE console
entry start
 
include 'win32a.inc'
 
section '.data' data readable writeable
ru db 'Russian',0
sm dd '_',0
m1 db '������� �������� �������: ',13,10,0
strMas db '������ �: ',13,10,0
strMasB db '������ �, ������������ �� ������� �4: ',13,10,0
strNumber db '������� ����� �������: ',13,10,0
A dd ?
mas dd ?
masB dd ?
i dd 0
k dd 0
j dd 0
p dd 0
N dd ?
plus dd 1
minus dd -1
neutral dd 0
string dd '%d', 0
probel db '(%d)', 0
qq db '-----------------',13,10,0
qqn db ' ', 13,10,0
 
section '.code' code readable executable
start:
   cinvoke setlocale,0,ru ;������������� ������
   call readMass          ; ��������� ���������, ��� ���������� �������
   push qq
   call [printf]
   push qqn
   call [printf]
   push strMas            ; ������� ��� ���� ���������
   call [printf]
   call printMass         ; ����������, ����� ��������� ������ �
   push qqn
   call [printf]
   push qqn
   call [printf]
   push qq
   call [printf]
   push qqn
   call [printf]
   call makeMasB          ; ������� �� ������� �4 ������ �
   push strMasB
   call [printf]
   call printMassB        ; ����������, ����� ��������� ������
   call [getch]
   push 0            ;����� �������, ��� ������ �� ���������
   call [ExitProcess]

proc readMass
   invoke printf, strNumber  ;������� ���������
   invoke scanf, string, N
   invoke GetProcessHeap
   mov [mas], eax
   mov ecx, 4
   imul ecx, [N]             ;����������� �������� ������ ��� ��������� ������
   invoke HeapAlloc, [mas],0,ecx
   mov [mas], eax
   push m1
   call [printf]
   add esp, 16
   lpl:
        invoke scanf, string, A ;�������� �����
        add esp, 8   ;�������� �� ����� ������ push'��, ����� ��������� ����� ��������
        mov edx, [mas]  ;������ �������� � �������, ����� ����� ���� ���������� � ��� ������

        mov ebx, [A]   ; �������� ��������� �������� � �������
        inc [i]        ;  ������������� �������
        mov eax, [i] ; �������� ������� � �������

        mov [edx+eax*4],ebx  ; �������� �������� � � ������ �������

        cmp eax, [N] ;  ��������� � ������ �������, ����� ����� �� �����
        jne lpl   ; ���� != �����, �� ��������� ����
    ret
endp

proc makeMasB
   invoke GetProcessHeap
   mov [masB], eax
   mov ecx, 4           ;����������� �������� ������ ��� ��������� ������
   imul ecx, [N]
   invoke HeapAlloc, [masB],0,ecx
   mov [masB], eax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      flexi:
        mov edx, [mas]   ;������ ������� � ������� � ��������
        mov ecx, [masB]
        inc [j]
        mov eax, [j]
        mov ebx, [edx+eax*4] ;���������� � ������ �������
        cmp ebx, 0           ;������ �������� �� ==0
        je equals            ;���� �����, �� ���� � ����� equals, ��� ��������� ������� � ������ �
        cmp ebx, 0
        jl less              ;������ �������� [�������]<0, ���� �����, �� ���� � ����� less
        mov ebx, [plus]
        mov [ecx+eax*4], ebx  ;���� ������� �������� �� ������, �� ������ ���������
                             ;� ������� ������ ������� � ������� � ��������� ����
        cmp eax, [N]
        je finish
        jmp flexi

      equals:
        mov edx, [masB]
        mov ecx, [j]
        mov eax, [neutral]      ;���������� � ������� ������ ������� B �������� 0
        mov [edx+ecx*4], eax
        cmp ecx, [N]
        je finish
        jmp flexi

      less:
        mov edx, [masB]
        mov ecx, [j]
        mov eax, [minus]     ;���������� � ������� ������ ������� B �������� -1
        mov [edx+ecx*4], eax
        cmp ecx, [N]
        je finish
        jmp flexi

      finish:
        ret
ret
endp


proc printMass

    flex:
        mov edx, [mas]
        inc [k]
        mov eax, [k]
        mov ecx,  [edx+eax*4]
        push ecx
        push probel
        call [printf]     ;���������� ������ �� ������� ������� � � �������� printf
        push sm
        call [printf]
        add esp, 12

        mov eax, [k]
        cmp eax,[N]
        jne flex

     ret
endp
proc printMassB

    flexq:
        mov edx, [masB]
        inc [p]
        mov eax, [p]
        mov ecx,  [edx+eax*4]
        push ecx
        push probel
        call [printf]   ;���������� ������ �� ������� ������� B � �������� printf
        push sm
        call [printf]
        add esp, 12

        mov eax, [p]
        cmp eax,[N]
        jne flexq

     ret
endp

section '.idata' import data readable
 
library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'
 
import kernel,\
       ExitProcess,'ExitProcess',\
       HeapAlloc, 'HeapAlloc',\
       GetProcessHeap, 'GetProcessHeap'
                                     ;��������������� ���������� � �������
import msvcrt,\
       setlocale,'setlocale',\
       printf,'printf',\
       scanf,'scanf',\
       system,'system',\
       getch, '_getch'
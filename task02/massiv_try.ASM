

;------------------ВАРИАНТ №4------------------
;Разработать программу, использующую динамическое выделение памяти под массив,
;которая вводит одномерный массив A[N], формирует из элементов массива  А новый массив В по правилам:
;Правило варианта №4: элемент В[i] = 1, если A[i]>0
;                             В[i]= -1, если A[i]<0
;                             В[i]=0, если A[i]=0

format PE console
entry start
 
include 'win32a.inc'
 
section '.data' data readable writeable
ru db 'Russian',0
sm dd '_',0
m1 db 'Введите элементы массива: ',13,10,0
strMas db 'Массив А: ',13,10,0
strMasB db 'Массив В, составленный по правилу №4: ',13,10,0
strNumber db 'Введите длину массива: ',13,10,0
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
   cinvoke setlocale,0,ru ;устанавливаем локаль
   call readMass          ; Запускаем процедуру, для заполнения массива
   push qq
   call [printf]
   push qqn
   call [printf]
   push strMas            ; Выводим еще одно сообщение
   call [printf]
   call printMass         ; Показываем, какой получился массив А
   push qqn
   call [printf]
   push qqn
   call [printf]
   push qq
   call [printf]
   push qqn
   call [printf]
   call makeMasB          ; Создаем по правилу №4 массив В
   push strMasB
   call [printf]
   call printMassB        ; Показываем, какой получился массив
   call [getch]
   push 0            ;Вызов функций, для выхода из программы
   call [ExitProcess]

proc readMass
   invoke printf, strNumber  ;Выводим сообщение
   invoke scanf, string, N
   invoke GetProcessHeap
   mov [mas], eax
   mov ecx, 4
   imul ecx, [N]             ;Динамически выделаем память под введенный размер
   invoke HeapAlloc, [mas],0,ecx
   mov [mas], eax
   push m1
   call [printf]
   add esp, 16
   lpl:
        invoke scanf, string, A ;считываю цифру
        add esp, 8   ;удаление из стека лишних push'ей, чтобы процедура верно работала
        mov edx, [mas]  ;массив кладется в регистр, чтобы можно было обратиться к его ячейке

        mov ebx, [A]   ; кладется введенное значение в регистр
        inc [i]        ;  увеличивается счетчик
        mov eax, [i] ; кладется счетчик в регистр

        mov [edx+eax*4],ebx  ; кладется значение А в ячейку массива

        cmp eax, [N] ;  сравнение с длиной массива, чтобы выйти из цикла
        jne lpl   ; если != длина, то повторяем цикл
    ret
endp

proc makeMasB
   invoke GetProcessHeap
   mov [masB], eax
   mov ecx, 4           ;Динамически выделаем память под введенный размер
   imul ecx, [N]
   invoke HeapAlloc, [masB],0,ecx
   mov [masB], eax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      flexi:
        mov edx, [mas]   ;кладем массивы и счетчик в регистры
        mov ecx, [masB]
        inc [j]
        mov eax, [j]
        mov ebx, [edx+eax*4] ;обращаемся к ячейке массива
        cmp ebx, 0           ;делаем проверку на ==0
        je equals            ;если верно, то идем в метку equals, где добавляем элемент в массив В
        cmp ebx, 0
        jl less              ;делаем проверку [элемент]<0, если верно, то идем в метку less
        mov ebx, [plus]
        mov [ecx+eax*4], ebx  ;если верхние проверки не прошли, то просто добавляем
                             ;в текущую ячейку массива В единицу и повторяем цикл
        cmp eax, [N]
        je finish
        jmp flexi

      equals:
        mov edx, [masB]
        mov ecx, [j]
        mov eax, [neutral]      ;Добавление в текущую ячейку массива B значения 0
        mov [edx+ecx*4], eax
        cmp ecx, [N]
        je finish
        jmp flexi

      less:
        mov edx, [masB]
        mov ecx, [j]
        mov eax, [minus]     ;Добавление в текущую ячейку массива B значения -1
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
        call [printf]     ;Проходимся циклом по ячейкам массива А и вызываем printf
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
        call [printf]   ;Проходимся циклом по ячейкам массива B и вызываем printf
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
                                     ;импортированные библиотеки и функции
import msvcrt,\
       setlocale,'setlocale',\
       printf,'printf',\
       scanf,'scanf',\
       system,'system',\
       getch, '_getch'
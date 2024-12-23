;elimina xoruri si linii fara dumnezeu
.model small
.stack 500h
.data
    hammingMatrix    DW 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0

    vArray           DW 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0

    zArray           DW 16 DUP(?)
    offsetzArray     DW 0
    error            DW 0
    noErrorMSG       DB "Codul nu are erori!", '$'
    tooManyErrorsMSG DB "Codul are mai mult de o eroare!", '$'

.code
    start:        
                  mov  ax, @data
                  mov  ds, ax
    
                  xor  ax, ax
                  xor  bx, bx
                  xor  dx, dx

                  mov  si, offset hammingMatrix
                  mov  di, offset vArray
                  mov  offsetzArray, offset zArray
                  mov  ch, 0

    innerLoop:    
                  add  ax, [si]
                  add  bx, [di]
                  mul  bx
                  add  dx, ax

                  add  si, type hammingMatrix
                  add  di, type vArray

                  inc  ch
                  cmp  ch, 16
                  jl   innerLoop

    outerLoop:    
                  add  offsetzArray, dx
                  inc  offsetzArray

                  xor  dx ,dx
                  mov  di, offset vArray
                  mov  ch, 0

                  inc  cl
                  cmp  cl, 5
                  jl   innerLoop
       
    ; eroarea se converteste in zecimal direct din vector
    ;daca nu vrea, incearca sa dai shr ax, 15 sa ramai cu un singur bit, dar cred ca o sa fie ok

                  xor  si, si
                  xor  bx, bx
                  xor  ax, ax

                  mov  si, offsetzArray
                  mov  ax, 1

                  mov  bx, [si]
                  cmp  bx, 1
                  je   addOne

    formError:    
                  sub  si, 1
                  mov  bx, [si]

                  cmp  bx, 1
                  mul  2
                  je   notEmpty

                  sub  cx, 1
                  cmp  cx, 0
                  ja   formError

                  jmp  chooseOutcome

    notEmpty:     
                  add  error, ax
                  jmp  formError
    addOne:       
                  add  erorr, 1

    ;add special cases, error = 0 sau 2
    ;daca e 1, modifica v

    chooseOutcome:
                  cmp  error, 0
                  je   noError

                  cmp  error, 16
                  jle  correctError

                  jmp  tooManyErrors

    noError:      
                  mov  ah, 09h
                  lea  dx, noErrorMSG
                  int  21h

                  jmp  stop
    tooManyErrors:
                  mov  ah, 09h
                  lea  dx, tooManyErrorsMSG
                  int  21h

                  jmp  stop
    correctError: 
                  mov  si, offsetzArray
                  add  si, error
    
                  cmp  word ptr [si], 1
                  je   oneToZero

                  add  word ptr [si], 1
                  jmp  printLoop

    oneToZero:    
                  xor  word ptr [si], 1
                  jmp  printLoop

    ;print
    ;               mov  cx, 16
    ;               mov  si, offsetzArray
    ; printLoop:    
    ;               mov  ax, [si]
    ;               call printArray

    ;               mov  ax, 2
    ;               mov  dx, ','
    ;               int  21h

    ;               mov  ax, 2
    ;               mov  dx, ' '
    ;               int  21h

    ;               inc si
    ;               loop printLoop
    ;               jmp stop

    ; printArray:   
                  
    stop:         
                  mov  ax, 4ch
                  int  21h

end start
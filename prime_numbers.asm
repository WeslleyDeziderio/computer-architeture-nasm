extern printf
extern scanf

global main

section .data
    msg1 dw 'Insira o número a ser verificado: ', 0H
    is_prime dw '1', 0AH, 0H
    is_not_prime dw '0', 0AH, 0H
    repeat_msg dw 'O programa será encerrado, deseja verificar outro número? (1 para repetir/0 para encerrar): ', 0H

    scan_int db '%d', 0H

section .text

global main
     is_prime_func:
        push ebp
        mov ebp, esp
        mov ecx, [ebp+8] ;valor de entrada será armazenado em ecx, haja vista que este será decrementado
        mov ebx, 1 ;assumindo que o valor inicial é 1
        ret
        
      divider:
        cmp ecx, 2 ;ecx <= 2, é primo
        jbe final_divider
        dec ecx
        mov eax, [ebp+8] ;entrada numerica que irá ser dividida
        xor edx, edx
        div ecx
        cmp edx, 0 ;resto da divisão é igual a zero?
        jnz divider ;se não for zero, continue a dividir por ecx-1
        mov ebx, 0 ;resto zero, então não é primo

    final_divider:
        mov eax, ebx 
        mov esp, ebp
        pop ebp
    
    main:
        push ebp
        mov ebp, esp
        sub esp, 4

        push msg1
        call printf
        add esp, 4

        push esp
        push scan_int
        call scanf
        add esp, 8

        push DWORD [esp] ;comando para carregar o valor 
        call is_prime_func
        cmp eax, 0
        jz isnt_prime_func
        mov eax, 1
        push is_prime
        call printf
        jmp repeat

    isnt_prime_func:
        mov eax, 0
        push is_not_prime
        call printf
        call repeat

    repeat: ;função causando falha de segmentação quando é pedido para encerrar
        push ebp
        mov ebp, esp
        sub esp, 4

        push repeat_msg
        call printf
        add esp, 4

        push esp
        push scan_int
        call scanf
        add esp, 8

        push DWORD [esp]
        push ebp ;armazenando valor em ebp
        mov ebp, esp

        mov eax, [ebp+8]

        cmp eax, 1 ;compare o valor do registrador com um
        je main ;se for um, volte a executar o programa (Essa lógica funciona)
        
        cmp eax, 0 ;compare o valor do registrador com zero
        je end ;se for zero, encerre o programa (Mas essa não, por quê?)
        
    end:
        mov esp, ebp
        pop ebp
        ret
        
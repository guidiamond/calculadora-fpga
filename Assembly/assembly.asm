INIT:
    Noop

RESET:
    Movc $0, %AL
    Movc $0, %AH
    Movc $0, %BL
    Movc $0, %BH
    Movc $0, %RL
    Movc $0, %RH

MAIN:
    Noop

ENTR_DADOS:
    Load Btn0, %AC
    Cmp $1, %AC
    Jnz ENTR_OP
    Jsr LE_DADOS

ENTRA_OP:
    Load Btn1, %AC
    Cmp $1, %AC
    Jnz INIT
    Jsr EXEC_OP

LE_DADOS:
    #Observa o valor do SW[8]
    Load %SW8, %AC
    Cmp $1, %AC
    Je SALVA_B   

SALVA_A:
    #Observa o valor do SW[9]
    Load %SW9, %AC
    Cmp $1, %AC
    Je SALVA_AH
    Jmp SALVA_AL   

SALVA_B:
    #Observa o valor do SW[9]
    Load %SW9, %AC
    Cmp $1, %AC
    Je SALVA_BH
    Jmp SALVA_BL   

SALVA_AL:
    Movc %BARR, %AL
    Jmp MAIN

SALVA_AH:
    Movc %BARR, %AH
    Jmp MAIN

SALVA_BL:
    Movc %BARR, %BL
    Jmp MAIN

SALVA_BH:
    Movc %BARR, %BH
    Jmp MAIN

EXEC_OP:
    Load %SW0, %AC
    Cmp $1, %AC
    Je SOMA
    Load %SW1, %AC
    Cmp $1, %AC
    Je SUB
    Load %SW2, %AC
    Cmp $1, %AC
    Je MULT
    Load %SW3, %AC
    Cmp $1, %AC
    Je DIV
    Load %SW4, %AC
    Cmp $1, %AC
    Je AND
    Load %SW5, %AC
    Cmp $1, %AC
    Je OR
    Load %SW6, %AC
    Cmp $1, %AC
    Je NOT
    Load %SW7, %AC
    Cmp $1, %AC
    Je XOR
    Jmp MAIN

SOMA:
    Mov %B, %AC # 16bits
    Add %A, %AC # 16bits
    Mov %AC, %R # 16bits
    Jmp MAIN

SUB:
    Mov %A, %AC # 16bits
    Sub %B, %AC # 16bits
    Mov %AC, %R # 16bits
    Jmp MAIN

MULT:
    Movc $0, %RL
    Movc $0, %RH
M_LOOP:    
    Mov %B, %AC # 16bits
    Cmp $0, %AC
    Jz MAIN
    Mov %A, %AC # 16bits
    Add %AC, %R # 16bits
    Dec %B      # 16bits
    Jmp M_LOOP

DIV:
    

AND:
    Mov %Mem2, %AC # 16bits - %Mem3 incluido
    And %Mem0, %AC # 16bits - %Mem1 incluído
    Mov %AC, %Mem4 # 16bits - %Mem4 incluído
    Jmp MAIN

OR:
    Mov %Mem2, %AC # 16bits - %Mem3 incluido
    Or %Mem0, %AC # 16bits - %Mem1 incluído
    Mov %AC, %Mem4 # 16bits - %Mem4 incluído
    Jmp MAIN

NOT:
    Not %Mem0
    Mov %Mem0, Mem4 # 16bits - %Mem4 incluído
    Jmp MAIN

XOR:
    Mov %Mem2, %AC # 16bits - %Mem3 incluido
    Xor %Mem0, %AC # 16bits - %Mem1 incluído
    Mov %AC, %Mem4 # 16bits - %Mem4 incluído
    Jmp MAIN

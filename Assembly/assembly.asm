INIT:
    MOV 0x00
    STORE 0x60 #AL
    STORE 0x61 #AH
    STORE 0x62 #BL
    STORE 0x63 #BH
    STORE 0x64 #RL
    STORE 0x65 #RH
    MOV 0x01
    STORE 0x70 #B0
    MOV 0x02
    STORE 0x71 #B1
    MOV 0x04
    STORE 0x72 #B2
    MOV 0x08
    STORE 0x73 #B3
    MOV 0x10
    STORE 0x74 #B4
    MOV 0x20
    STORE 0x75 #B5
    MOV 0x40
    STORE 0x76 #B6
    MOV 0x80
    STORE 0x77 #B7
    MOV 0x00
    STORE 0x80 #ZERO
    MOV 0x01
    STORE 0x81 #UM

MAIN:
    LOAD 0x2A #BTN0
    CMP 0x81 #UM
    JE SALVA
    LOAD 0x2B #BTN1
    CMP 0x81 #UM
    JE OPERACAO
    JMP MAIN

SALVA:
    LOAD 0x28 #SW8
    CMP 0x81 #UM
    JE SALVA_B   

SALVA_A:
    LOAD 0x29 #SW9
    CMP 0x80 #ZERO
    JE SALVA_AL
    JMP SALVA_AH   

SALVA_B:
    LOAD 0x29 #SW9
    CMP 0x80 #ZERO
    JE SALVA_BL
    JMP SALVA_BH   

OPERACAO:
    LOAD 0x20 #SW0
    CMP 0x81 #UM
    JE SOMA
    LOAD 0x21 #SW1
    CMP 0x81 #UM
    JE SUB
    LOAD 0x22 #SW2
    CMP 0x81 #UM
    JE MULT
    LOAD 0x23 #SW3
    CMP 0x81 #UM
    JE DIV
    LOAD 0x24 #SW4
    CMP 0x81 #UM
    JE AND
    LOAD 0x25 #SW5
    CMP 0x81 #UM
    JE OR
    LOAD 0x26 #SW6
    CMP 0x81 #UM
    JE NOT
    LOAD 0x27 #SW7
    CMP 0x81 #UM
    JE XOR
    JMP MAIN

SOMA:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    LOAD 0x62 #BL
    ADD 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    LOAD 0x63 #BH
    ADD 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN

SUB:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    LOAD 0x62 #BL
    SUB 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    LOAD 0x63 #BH
    SUB 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN

MULT:
    MOV 0x00
    STORE 0x64 #RL
    STORE 0x65 #RH
    LOAD 0x62 #BL
    STORE 0x66 #TMPL
    LOAD 0x63 #BH
    STORE 0x67 #TMPH

M_LOOP:    
    LOAD 0x66 #TMPL
    ADD 0x67 #TMPH
    CMP 0x80 #ZERO
    JE MAIN
    LOAD 0x60 #AL
    ADD 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    ADD 0x65 #RH
    STORE 0x65 #RH
    LOAD 0x66 #TMPL
    SUB 0x81 #UM
    STORE 0x66 #TMPL
    JMP M_LOOP

DIV:
    MOV 0x00
    STORE 0x64 #RL
    STORE 0x65 #RH
    LOAD 0x60 #AL
    STORE 0x66 #TMPL
    LOAD 0x61 #AH
    STORE 0x67 #TMPH
D_LOOP:    
    LOAD 0x67 #TMPH
    CMP 0x63 #BH
    JL MAIN
    JE COMPL
    JMP D_CONT
COMPL:
    LOAD 0x66 #TMPL
    CMP 0x62 #BL
    JL MAIN
D_CONT:
    LOAD 0x66 #TMPL
    SUB 0x62 #BL
    STORE 0x66 #TMPL
    LOAD 0x67 #TMPH
    SUB 0x63 #BH
    STORE 0x67 #TMPH
    LOAD 0x64 #RL
    ADD 0x81 #UM
    STORE 0x64 #RL
    JMP D_LOOP

AND:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    LOAD 0x62 #BL
    AND 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    LOAD 0x63 #BH
    AND 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN

OR:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    LOAD 0x62 #BL
    OR 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    LOAD 0x63 #BH
    OR 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN

NOT:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    NOT 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    NOT 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN

XOR:
    LOAD 0x60 #AL
    STORE 0x64 #RL
    LOAD 0x62 #BL
    XOR 0x64 #RL
    STORE 0x64 #RL
    LOAD 0x61 #AH
    STORE 0x65 #RH
    LOAD 0x63 #BH
    XOR 0x65 #RH
    STORE 0x65 #RH
    JMP MAIN


SALVA_AL: 
        MOV 0x00
        STORE 0x60 #AL
SW0AL:  LOAD 0x20 #SW0
        CMP 0x80 #ZERO
        JE SW1AL
        LOAD 0x60 #AL
        ADD 0x70 #B0
        STORE 0x60 #AL
SW1AL:  LOAD 0x21 #SW1
        CMP 0x80 #ZERO
        JE SW2AL
        LOAD 0x60 #AL
        ADD 0x71 #B1
        STORE 0x60 #AL
SW2AL:  LOAD 0x22 #SW2
        CMP 0x80 #ZERO
        JE SW3AL
        LOAD 0x60 #AL
        ADD 0x72 #B2
        STORE 0x60 #AL
SW3AL:  LOAD 0x23 #SW3
        CMP 0x80 #ZERO
        JE SW4AL
        LOAD 0x60 #AL
        ADD 0x73 #B3
        STORE 0x60 #AL
SW4AL:  LOAD 0x24 #SW4
        CMP 0x80 #ZERO
        JE SW5AL
        LOAD 0x60 #AL
        ADD 0x74 #B4
        STORE 0x60 #AL
SW5AL:  LOAD 0x25 #SW5
        CMP 0x80 #ZERO
        JE SW6AL
        LOAD 0x60 #AL
        ADD 0x75 #B5
        STORE 0x60 #AL
SW6AL:  LOAD 0x26 #SW6
        CMP 0x80 #ZERO
        JE SW7AL
        LOAD 0x60 #AL
        ADD 0x76 #B6
        STORE 0x60 #AL
SW7AL:  LOAD 0x27 #SW7
        CMP 0x80 #ZERO
        JE MAIN
        LOAD 0x60 #AL
        ADD 0x77 #B7
        STORE 0x60 #AL
        JMP MAIN
    
SALVA_AH: 
        MOV 0x00
        STORE 0x61 #AH
SW0AH:  LOAD 0x20 #SW0
        CMP 0x80 #ZERO
        JE SW1AH
        LOAD 0x61 #AH
        ADD 0x70 #B0
        STORE 0x61 #AH
SW1AH:  LOAD 0x21 #SW1
        CMP 0x80 #ZERO
        JE SW2AH
        LOAD 0x61 #AH
        ADD 0x71 #B1
        STORE 0x61 #AH
SW2AH:  LOAD 0x22 #SW2
        CMP 0x80 #ZERO
        JE SW3AH
        LOAD 0x61 #AH
        ADD 0x72 #B2
        STORE 0x61 #AH
SW3AH:  LOAD 0x23 #SW3
        CMP 0x80 #ZERO
        JE SW4AH
        LOAD 0x61 #AH
        ADD 0x73 #B3
        STORE 0x61 #AH
SW4AH:  LOAD 0x24 #SW4
        CMP 0x80 #ZERO
        JE SW5AH
        LOAD 0x61 #AH
        ADD 0x74 #B4
        STORE 0x61 #AH
SW5AH:  LOAD 0x25 #SW5
        CMP 0x80 #ZERO
        JE SW6AH
        LOAD 0x61 #AH
        ADD 0x75 #B5
        STORE 0x61 #AH
SW6AH:  LOAD 0x26 #SW6
        CMP 0x80 #ZERO
        JE SW7AH
        LOAD 0x61 #AH
        ADD 0x76 #B6
        STORE 0x61 #AH
SW7AH:  LOAD 0x27 #SW7
        CMP 0x80 #ZERO
        JE MAIN
        LOAD 0x61 #AH
        ADD 0x77 #B7
        STORE 0x61 #AH
        JMP MAIN

SALVA_BL: 
        MOV 0x00
        STORE 0x62 #BL
SW0BL:  LOAD 0x20 #SW0
        CMP 0x80 #ZERO
        JE SW1BL
        LOAD 0x62 #BL
        ADD 0x70 #B0
        STORE 0x62 #BL
SW1BL:  LOAD 0x21 #SW1
        CMP 0x80 #ZERO
        JE SW2BL
        LOAD 0x62 #BL
        ADD 0x71 #B1
        STORE 0x62 #BL
SW2BL:  LOAD 0x22 #SW2
        CMP 0x80 #ZERO
        JE SW3BL
        LOAD 0x62 #BL
        ADD 0x72 #B2
        STORE 0x62 #BL
SW3BL:  LOAD 0x23 #SW3
        CMP 0x80 #ZERO
        JE SW4BL
        LOAD 0x62 #BL
        ADD 0x73 #B3
        STORE 0x62 #BL
SW4BL:  LOAD 0x24 #SW4
        CMP 0x80 #ZERO
        JE SW5BL
        LOAD 0x62 #BL
        ADD 0x74 #B4
        STORE 0x62 #BL
SW5BL:  LOAD 0x25 #SW5
        CMP 0x80 #ZERO
        JE SW6BL
        LOAD 0x62 #BL
        ADD 0x75 #B5
        STORE 0x62 #BL
SW6BL:  LOAD 0x26 #SW6
        CMP 0x80 #ZERO
        JE SW7BL
        LOAD 0x62 #BL
        ADD 0x76 #B6
        STORE 0x62 #BL
SW7BL:  LOAD 0x27 #SW7
        CMP 0x80 #ZERO
        JE MAIN
        LOAD 0x62 #BL
        ADD 0x77 #B7
        STORE 0x62 #BL
        JMP MAIN

SALVA_BH: 
        MOV 0x00
        STORE 0x63 #BH
SW0BH:  LOAD 0x20 #SW0
        CMP 0x80 #ZERO
        JE SW1BH
        LOAD 0x63 #BH
        ADD 0x70 #B0
        STORE 0x63 #BH
SW1BH:  LOAD 0x21 #SW1
        CMP 0x80 #ZERO
        JE SW2BH
        LOAD 0x63 #BH
        ADD 0x71 #B1
        STORE 0x63 #BH
SW2BH:  LOAD 0x22 #SW2
        CMP 0x80 #ZERO
        JE SW3BH
        LOAD 0x63 #BH
        ADD 0x72 #B2
        STORE 0x63 #BH
SW3BH:  LOAD 0x23 #SW3
        CMP 0x80 #ZERO
        JE SW4BH
        LOAD 0x63 #BH
        ADD 0x73 #B3
        STORE 0x63 #BH
SW4BH:  LOAD 0x24 #SW4
        CMP 0x80 #ZERO
        JE SW5BH
        LOAD 0x63 #BH
        ADD 0x74 #B4
        STORE 0x63 #BH
SW5BH:  LOAD 0x25 #SW5
        CMP 0x80 #ZERO
        JE SW6BH
        LOAD 0x63 #BH
        ADD 0x75 #B5
        STORE 0x63 #BH
SW6BH:  LOAD 0x26 #SW6
        CMP 0x80 #ZERO
        JE SW7BH
        LOAD 0x63 #BH
        ADD 0x76 #B6
        STORE 0x63 #BH
SW7BH:  LOAD 0x27 #SW7
        CMP 0x80 #ZERO
        JE MAIN
        LOAD 0x63 #BH
        ADD 0x77 #B7
        STORE 0x63 #BH
        JMP MAIN

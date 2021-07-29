.global _start
_start:
    SUB R0, R15, R15
        //R1 = 1.0 = 0x3f800000 = 1065353216 = 2^23*127
    ADD R1, R0, #32
    MUL R1, R1, R1       //R1 = 2^10
    MUL R1, R1, R1       //R1 = 2^20
    ADD R2, R0, #8
    MUL R1, R1, R2       //R1 = 2^23
    ADD R2, R0, #127
    MUL R1, R1, R2       //R1 = 2^23*127 = 1.0
        //R2 = 0.5 = 0X3f000000 = 1056964608 = 2^24*63
    ADD R2, R0, #64      //R2 = 2^6
    MUL R2, R2, R2       //R2 = 2^12
    MUL R2, R2, R2       //R2 = 2^24
    ADD R3, R0, #63
    MUL R2, R2, R3       //R2 = 2^24*63 = 0.5 en FP

    ADD R5, R1, #0       //R5 = Respuesta

    ADD R3, R0, #3       //i = 3
    LOOP:
        SUBS R3, R3, #1  //i = i - 1
        BEQ END          //i = 0? Goto End
        VMUL R1, R1, R2  //R1 = R1 * R2
        VADD R5, R5, R1  //R5 = R5 + R1
        B LOOP           //Loop
    END:
    STR R5, [R0, #200]   //mem[200] = Respuesta
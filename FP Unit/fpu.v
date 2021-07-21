module fpu(
    a,
    b,
    FPUControl,
    Result
);
    //32 bits: 1 bit sign, 8 bit expo, 23 bit mantisa
    //16 bits. 1 bit sign, 5 bit expo, 10 bit mantisa
    input [31:0] a, b;
    input [1:0] FPUControl;  //00 suma 16 bits, 01 suma 32 bits, 10 producto 16 bits, 11 producto 32 bits
    output reg [31:0] Result;

    reg signA;
    reg signB;
    reg [31:0] expoA;
    reg [31:0] expoB;
    reg [31:0] mantA;
    reg [31:0] mantB;
    
    reg signR = 1'b0;
    reg [31:0] expoR;
    reg [31:0] mantR;

    reg [1:0] control;

    always @(*) begin
        control = FPUControl;
        //Separo los componentes
        signA = FPUControl[0] ? a[31] : a[15];
        signB = FPUControl[0] ? b[31] : b[15];
        
        //Agrego 24 o 27 zeros delante del exponente
        expoA = FPUControl[0] ? {24'b0, a[30:23]} : {27'b0, a[14:10]};
        expoB = FPUControl[0] ? {24'b0, b[30:23]} : {27'b0, b[14:10]};

        //Agrego un 1 delante de la mantisa
        mantA = FPUControl[0] ? {9'b1, a[22:0]} : {22'b1, a[9:0]};
        mantB = FPUControl[0] ? {9'b1, b[22:0]} : {22'b1, b[9:0]};
        
        if (FPUControl[1] == 1'b0) begin
            if (expoA > expoB) begin
                expoR = expoA;
                mantB = mantB >> (expoA - expoB);
            end
            else begin
                expoR = expoB;
                mantA = mantA >> (expoB - expoA);
            end
            mantR = mantA + mantB;

            if (control[0] ? (mantR[24] == 1'b1) : (mantR[11] == 1'b1)) begin
                //Overflow
                mantR = mantR >> 1'b1;
                expoR = expoR + 1'b1;
            end

            //Quitar el 1 delante de la mantisa
            mantR = FPUControl[0] ? mantR[22:0] : mantR[9:0];
        end
        
        Result = FPUControl[0] ? {signR, expoR[7:0], mantR[22:0]} : {signR, expoR[4:0], mantR[9:0]};
    end
    
endmodule
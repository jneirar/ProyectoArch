module fpu(
    a,
    b,
    FPUControl,
    Result,
    FPUFlags
);
    //32 bits: 1 bit sign, 8 bit expo, 23 bit mantisa
    //16 bits. 1 bit sign, 5 bit expo, 10 bit mantisa
    input [31:0] a, b;
    input [1:0] FPUControl;  //00 suma 16 bits, 01 suma 32 bits, 10 producto 16 bits, 11 producto 32 bits
    output reg [31:0] Result;
    output wire [3:0] FPUFlags;

    wire neg, zero, carry, overflow;

    reg signA;
    reg signB;
    reg [31:0] expoA;
    reg [31:0] expoB;
    reg [31:0] mantA;
    reg [31:0] mantB;
    
    reg sumaResta;
    reg signR;
    reg [31:0] expoR;
    reg [31:0] mantR;
    reg [31:0] mantAshift;
    reg [31:0] mantBshift;
    reg [47:0] productoPosible;
    reg [31:0] aux;
    reg [47:0] aux2;
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
        
        if (~FPUControl[1]) begin
            //Suma
            if ((a == 0 && b != 0) || a != 0 && b == 0) begin
                signR = (a == 0) ? signB : signA;
                expoR = (a == 0) ? expoB : expoA;
                mantR = (a == 0) ? mantB : mantA;
            end
            else if ((a == 0 && b == 0) || (signA != signB && expoA == expoB && mantA == mantB)) begin
                signR = 0;
                expoR = 0;
                mantR = 0;
            end
            else begin
                if (expoA > expoB) begin
                    expoR = expoA;
                    mantB = mantB >> (expoA - expoB);
                end
                else begin
                    expoR = expoB;
                    mantA = mantA >> (expoB - expoA);
                end

                //sumaResta, //0 sumar, 1 restar
                sumaResta = ~(signA == signB);

                if (sumaResta) begin
                    if (mantA > mantB) begin
                        mantR = mantA - mantB;
                        signR = signA;
                    end
                    else begin
                        mantR = mantB - mantA;
                        signR = signB;
                    end
                end
                else begin
                    mantR = mantA + mantB;
                    signR = signA;
                end
                    
                if (sumaResta) begin
                    //RESTA: Busco el primer 1
                    //mantR != 0, porque valido al inicio
                    aux = 0;
                    //En aux guardo en qué bit está el primer 1 a la izquierda
                    //naturalmente es menor a 23 o 10, ya que restamos el mayor - menor
                    aux2 = mantR;
                    while(~aux2[31]) begin
                        aux2 = aux2 << 1;
                        aux = aux + 1;
                    end
                    aux = 31 - aux;
                    //Este bit debe regresar a la posicion 23 o 10 para normalizar la mantisa
                    //Cada desplazamiento debe restar 1 al exponente
                    mantR = mantR << ((FPUControl[0] ? 23 : 10) - aux);
                    expoR = expoR - ((FPUControl[0] ? 23 : 10) - aux);
                end
                else begin
                    //SUMA:
                    if ((control[0] && mantR[24] == 1'b1) || (~control[0] && mantR[11] == 1'b1)) begin
                        //Overflow
                        mantR = mantR >> 1'b1;
                        expoR = expoR + 1'b1;
                    end
                end
                
                //Quitar el 1 delante de la mantisa
                mantR = FPUControl[0] ? mantR[22:0] : mantR[9:0];
            end
        end
        else begin
            if (a == 0 || b == 0) begin
                signR = 0;
                expoR = 0;
                mantR = 0;
            end
            else begin
                expoR = expoA + expoB - (FPUControl[0] ? 8'b01111111 : 5'b01111);
                //Desplazo a la derecha las mantisas eliminando todos los ending zeros.
                mantAshift = 0; //Guarda cuantos bits a la derecha se mueve.
                mantBshift = 0;
                while(~mantA[0]) begin
                    mantA = mantA >> 1;
                    mantAshift = mantAshift + 1;
                end
                while(~mantB[0]) begin
                    mantB = mantB >> 1;
                    mantBshift = mantBshift + 1;
                end
                
                //Multiplico las mantisas, máximo número puede ser de 48 bits o 22 bits
                if (FPUControl[0])
                    productoPosible = {16'b0, mantA} * {16'b0, mantB};
                else
                    productoPosible = mantA * mantB;
                
                aux = 0;
                //productoPosible tiene 1 o 2 bits de parte entera
                //En aux guardo en qué bit está el primer 1 a la izquierda
                aux2 = productoPosible;
                while(~aux2[47]) begin
                    aux2 = aux2 << 1;
                    aux = aux + 1;
                end
                aux = 47 - aux;
                //Si aux+1 - # bits decimales en ambas mantisas > 1 (=2), sumo uno al exponente
                if ( ( (aux + 1) - ((FPUControl[0] ? 23 : 10) - mantAshift + (FPUControl[0] ? 23 : 10) - mantBshift) ) > 1) begin
                    expoR = expoR + 1;
                end

                //Caso 1: aux = 23, entonces ya tiene forma de mantisa (leading 1 y 23 bits después, 0 a 22)
                //Caso 1: aux = 10, entonces ya tiene forma de mantisa (leading 1 y 10 bits después, 0 a 9)
                //Caso 2: aux > 23, shift right, se puede perder información en los bits menos significativos
                //Caso 2: aux > 10, shift right, se puede perder información en los bits menos significativos
                if (aux > (FPUControl[0] ? 23 : 10))
                    productoPosible = productoPosible >> (aux - (FPUControl[0] ? 23 : 10));
                //Caso 3: aux < 23, shift left para darle forma
                //Caso 3: aux < 10, shift left para darle forma
                if (aux < (FPUControl[0] ? 23 : 10))
                    productoPosible = productoPosible << ((FPUControl[0] ? 23 : 10) - aux);

                //Quitar el 1 delante de la mantisa
                mantR = FPUControl[0] ? productoPosible[22:0] : productoPosible[9:0];

                //Signo
                signR = signA ^ signB;
            end
        end
        Result = FPUControl[0] ? {signR, expoR[7:0], mantR[22:0]} : {signR, expoR[4:0], mantR[9:0]};
    end

    assign carry = 1'b0;
    assign overflow = 1'b0;
    assign neg = FPUControl[0] ? Result[31] : Result[15];
    assign zero = Result == 32'b0;
    
    assign FPUFlags = {neg, zero, carry, overflow};

endmodule
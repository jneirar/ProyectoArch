//MODIFICAR (en testvector tbn):
`timescale 1ns/1ns

module alu_tb();
    reg clk, reset;
    reg [31:0] a,b;
    reg [31:0] Result_1_expected; // to compare y output
    reg [31:0] Result_2_expected; // to compare y output
    reg [3:0] ALUFlags_expected;  // to compare y output
    reg [2:0] ALUControl;

    wire [31:0] Result1;
    wire [31:0] Result2;
    wire [3:0] ALUFlags;
    
    reg [31:0] vectornum; // check testvector number
    reg [31:0] errors; // error counter
    
    reg [134:0] testvector[1000:0];

    alu dut(.a(a), .b(b), .ALUControl(ALUControl), .Result1(Result1), .Result2(Result2), .ALUFlags(ALUFlags));
    
    always// always execute
        begin
            clk=1; #5; clk=0; #5;   //period? Tc= 10
        end
    
    initial // one exec 
        begin
            $readmemh("testvector.tv",testvector); //read in hexa
            errors=0;
            vectornum=0;
            reset=1; #17;reset=0;
        end
    
    always @(posedge clk)
        begin
           {ALUControl, a, b, Result_1_expected, Result_2_expected, ALUFlags_expected} = testvector[vectornum];
        end
    
    always @(negedge clk)
        begin
            if (~reset)
                begin 
                    if ((Result1 !== Result_1_expected || Result2 !== Result_2_expected || ALUFlags !== ALUFlags_expected)) 
                        begin
                          $display("testvector: %h",testvector[vectornum]);
                          $display("Vectornum: %d",vectornum);
                          $display("Error input a: %h",{a});
                          $display("Error input b: %h",{b});
                          $display("Error input ALUControl: %h",{ALUControl});
                          $display("output Result_1:%h, Result_1_expected:%h",Result1,Result_1_expected);
                          $display("output Result_2:%h, Result_2_expected:%h",Result2,Result_2_expected);
                          $display("output ALUFlags:%h, ALUFlags_expected:%h",ALUFlags,ALUFlags_expected);
                          errors=errors+1; 
                        end
                    vectornum=vectornum+1;
                
                    if (testvector[vectornum][0] === 1'bx)
                        begin
                            $display("total errors: %d",errors);
                            $finish;
                        end  
                end
        end
    initial begin
      $dumpfile("alu.vcd");
      $dumpvars;
    end
endmodule
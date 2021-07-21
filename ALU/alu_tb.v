//MODIFICAR (en testvector tbn):
`timescale 1ns/1ns

/*
//testvector.tv
//FPUControl_A_B_Resultexpected
*/

module fpu_tb();
    reg [31:0] a,b;
    reg [1:0] FPUControl;
    wire [31:0] Result;

    reg clk, reset;
    reg [101:0] testvector[1000:0];
    
    reg [31:0] Result_expected; // to compare y output
    reg [31:0] vectornum; // check testvector number
    reg [31:0] errors; // error counter
    
    fpu dut(.a(a), .b(b), .FPUControl(FPUControl), .Result(Result));
    
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
            Result_expected = testvector[vectornum][31:0];
            a = testvector[vectornum][63:32];
            b = testvector[vectornum][95:64];
            FPUControl = testvector[vectornum][97:96];
        end
    
    always @(negedge clk)
        begin
            if (~reset)
                begin 
                    if ((Result !== Result_expected))  // ===, == 
                        begin
                          $display("testvector: %h",testvector[vectornum]);
                          $display("Vectornum: %d",vectornum);
                          $display("Error input a: %h",{a});
                          $display("Error input b: %h",{b});
                          $display("Error input FPUControl: %h",{FPUControl});
                          $display("output Result:%h, Result_expected:%h",Result,Result_expected);
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
      $dumpfile("fpu.vcd");
      $dumpvars;
    end
endmodule
`timescale 1ns/1ns

/*
//testvector.tv
//FPUControl_A_B_Resultexpected
//01
//1.0 + 1.0=2.0
//23.0 + 15.5 = 38.5
//7.875 + 0.1875 = 8.0625
//0.125 + 100032.125 = 100032.25
//1.5 + 1.5 = 3.0
//1.5 + 0 = 1.5
//0 + 1.5 = 1.5
//-1.5 + 1.5 = 0
//1.5 - 1.5 = 0
//6.875 - 15.5 = -8.625
//15.5 - 6.875 = 8.625
//00
//1.625 + 0.5 = 2.125 
//0.875 + 10.5 = 11.375
//64.4375+18.015625 = 82.453125
//11:
//1.0 * 1.0 = 1.0
//1.5 * 1.5 = 2.25
//312.4375 * 124.8125 = 38996.10546875
//0.03125 * 7.8125 = 0.244140625 
//-1*-1 = 1
//-1*1 = -1
//1*-1 = -1
//1*1=1
//0*0=0
//10:
//1.625 * 0.5 = 0.8125
//0.03125 * 7.8125 = 0.244140625 
//0*0=0
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
`timescale 1ns/1ns

/*
//testvector.tv
//FPUControl_A_B_Resultexpected
//01
//0:    1.0 + 1.0=2.0
//1:    23.0 + 15.5 = 38.5
//2:    7.875 + 0.1875 = 8.0625
//3:    0.125 + 100032.125 = 100032.25
//4:    1.5 + 1.5 = 3.0
//5:    1.5 + 0 = 1.5
//6:    0 + 1.5 = 1.5
//7:    -1.5 + 1.5 = 0
//8:    1.5 - 1.5 = 0
//9:    6.875 - 15.5 = -8.625
//10:   15.5 - 6.875 = 8.625

//00
//11:   1.625 + 0.5 = 2.125 
//12:   0.875 + 10.5 = 11.375
//13:   64.4375+18.015625 = 82.453125

//11:
//14:   1.0 * 1.0 = 1.0
//15:   1.5 * 1.5 = 2.25
//16:   312.4375 * 124.8125 = 38996.10546875
//17:   0.03125 * 7.8125 = 0.244140625 
//18:   -1.0*-1.0 = 1.0
//19:   -1.0*1.0 = -1.0
//20:   1.0*-1.0 = -1.0
//21:   1.0*0.0=0.0
//22:   0.0*0.0=0.0

//10:
//23:   1.625 * 0.5 = 0.8125
//24:   0.03125 * 7.8125 = 0.244140625 
//25:   0.0*0.0=0.0
*/

module fpu_tb();
    reg [31:0] a,b;
    reg [1:0] FPUControl;
    wire [31:0] Result;
    wire [3:0] FPUFlags;

    reg clk, reset;
    reg [101:0] testvector[1000:0];
    
    reg [31:0] Result_expected; // to compare y output
    reg [3:0] FPUFlags_expected; // to compare y output
    reg [31:0] vectornum; // check testvector number
    reg [31:0] errors; // error counter
    
    fpu dut(.a(a), .b(b), .FPUControl(FPUControl), .Result(Result), .FPUFlags(FPUFlags));
    
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
            FPUFlags_expected = testvector[vectornum][3:0];
            Result_expected = testvector[vectornum][35:4];
            a = testvector[vectornum][67:36];
            b = testvector[vectornum][99:68];
            FPUControl = testvector[vectornum][101:100];
        end
    
    always @(negedge clk)
        begin
            if (~reset)
                begin 
                    if ((Result !== Result_expected) || (FPUFlags !== FPUFlags_expected))  // ===, == 
                        begin
                          $display("testvector: %h",testvector[vectornum]);
                          $display("Vectornum: %d",vectornum);
                          $display("Error input a: %h",{a});
                          $display("Error input b: %h",{b});
                          $display("Error input FPUControl: %h",{FPUControl});
                          $display("output Result:%h, Result_expected:%h",Result,Result_expected);
                          $display("output FPUFlags:%h, FPUFlags_expected:%h",FPUFlags,FPUFlags_expected);
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
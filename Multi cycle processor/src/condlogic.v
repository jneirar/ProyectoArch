// ADD CODE BELOW
// Add code for the condlogic and condcheck modules. Remember, you may
// reuse code from prior labs.
`include "condcheck.v"

module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	PCWrite,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire NextPC;
	input wire RegW;
	input wire MemW;
	output wire PCWrite;
	output wire RegWrite;
	output wire MemWrite;
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	wire CondExReg;
	
	assign FlagWrite = CondEx == 1 ? FlagW : 2'b00;
	// Delay writing flags until ALUWB state
	/*flopr #(2) flagwritereg(
		.clk(clk),
		.reset(reset),
		.d(FlagW & {2 {CondEx}}),
		.q(FlagWrite)
	);*/

	// ADD CODE HERE
	flopenr #(2) flagsreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);

	flopenr #(2) flagsreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);

    flopr #(1) condexreg(
        .clk(clk),
		.reset(reset),
        .d(CondEx),
        .q(CondExReg)
    );

    condcheck cc(
        .Cond(Cond),
        .Flags(Flags),
        .CondEx(CondEx)
    );

    assign PCWrite = NextPC | (PCS & CondExReg);
    assign RegWrite = RegW & CondExReg;
    assign MemWrite = MemW & CondExReg;
endmodule
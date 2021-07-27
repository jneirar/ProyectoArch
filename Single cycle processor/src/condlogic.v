`include "flopenr.v"
`include "condcheck.v"

module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FPUFlags,
	FlagW,
	PCS,
	RegW,
	MemW,
	FlagSrc,
	FPUFlagW,
	PCSrc,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [3:0] FPUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire RegW;
	input wire MemW;
	input wire FlagSrc;
	input wire [1:0] FPUFlagW;
	output wire PCSrc;
	output wire RegWrite;
	output wire MemWrite;
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	wire [1:0] FlagWmux;
	wire [3:0] Flagsmux;

	mux2 #(2) muxFlagW(
		.d0(FlagW),
		.d1(FPUFlagW),
		.s(FlagSrc),
		.y(FlagWmux)
	);
	mux2 #(4) muxFlags(
		.d0(ALUFlags),
		.d1(FPUFlags),
		.s(FlagSrc),
		.y(Flagsmux)
	);
	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(Flagsmux[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(Flagsmux[1:0]),
		.q(Flags[1:0])
	);
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	assign FlagWrite = FlagWmux & {2 {CondEx}};
	assign RegWrite = RegW & CondEx;
	assign MemWrite = MemW & CondEx;
	assign PCSrc = PCS & CondEx;
endmodule
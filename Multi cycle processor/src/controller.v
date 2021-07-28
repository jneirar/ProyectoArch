`include "decode.v"
`include "condlogic.v"

module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	PCWrite,
	MemWrite,
	RegWrite,
	IRWrite,
	AdrSrc,
	RegSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	ImmSrc,
	ALUControl,
	FPUFlags,
	FPUControl,
	ResSrc,
	MulWrite,
	MulOp
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	output wire PCWrite;
	output wire MemWrite;
	output wire RegWrite;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] RegSrc;
	output wire [1:0] ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ResultSrc;
	output wire [1:0] ImmSrc;
	output wire [2:0] ALUControl;
	wire [1:0] FlagW;
	wire PCS;
	wire NextPC;
	wire RegW;
	wire MemW;
	
	input wire [3:0] FPUFlags;
	output wire [1:0] FPUControl;
	output wire ResSrc;
	wire [1:0] FPUFlagW;
	input wire [3:0] MulOp;
	output wire MulWrite;

	decode dec(
		.clk(clk),
		.reset(reset),
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ResultSrc(ResultSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.FPUControl(FPUControl),
		.ResSrc(ResSrc),
		.FPUFlagW(FPUFlagW),
		.MulOp(MulOp),
		.MulWrite(MulWrite)
	);
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(Instr[31:28]),
		.ALUFlags(ALUFlags),
		.FlagW(FlagW),
		.PCS(PCS),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.PCWrite(PCWrite),
		.RegWrite(RegWrite),
		.MemWrite(MemWrite),
		.ResSrc(ResSrc),
		.FPUFlagW(FPUFlagW),
		.FPUFlags(FPUFlags)
	);
endmodule
`include "adder.v"
`include "flopr.v"
`include "regfile.v"
`include "extend.v"
`include "alu.v"
`include "fpu.v"

module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	MulWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	FPUControl,
	MemtoReg,
	PCSrc,
	ResSrc,
	ALUFlags,
	FPUFlags,
	PC,
	Instr,
	OPResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire MulWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [2:0] ALUControl;
	input wire [1:0] FPUControl;
	input wire MemtoReg;
	input wire PCSrc;
	input wire ResSrc;
	output wire [3:0] ALUFlags;
	output wire [3:0] FPUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] OPResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [31:0] ALUResult1;
	wire [31:0] ALUResult2;
	wire [31:0] FPUResult;
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.we4(MulWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(Instr[15:12]),
		.wa4(Instr[19:16]),
		.wd3(Result),
		.wd4(ALUResult2),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData)
	);
	mux2 #(32) resmux(
		.d0(OPResult),
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	mux2 #(32) srcbmux(
		.d0(WriteData),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		.a(SrcA),
		.b(SrcB),
		.ALUControl(ALUControl),
		.Result1(ALUResult1),
		.Result2(ALUResult2),
		.ALUFlags(ALUFlags)
	);
	fpu fpu(
		.a(SrcA),
		.b(SrcB),
		.FPUControl(FPUControl),
		.Result(FPUResult),
		.FPUFlags(FPUFlags)
	);
	mux2 #(32) resSrcmux(
		.d0(ALUResult1),
		.d1(FPUResult),
		.s(ResSrc),
		.y(OPResult)
	);
endmodule
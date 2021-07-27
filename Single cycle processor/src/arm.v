`include "controller.v"
`include "datapath.v"
`include "mux2.v"

module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	OPResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] OPResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire [3:0] FPUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	wire ResSrc;
	wire [1:0] FPUControl;
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.FPUFlags(FPUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ResSrc(ResSrc),
		.FPUControl(FPUControl)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.FPUControl(FPUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ResSrc(ResSrc),
		.ALUFlags(ALUFlags),
		.FPUFlags(FPUFlags),
		.PC(PC),
		.Instr(Instr),
		.OPResult(OPResult),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
endmodule
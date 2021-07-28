`include "mainfsm.v"

module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl,
	FPUControl,
	ResSrc,
	FPUFlagW,
	MulOp,
	MulWrite
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire [1:0] ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [2:0] ALUControl;
	wire Branch;
	wire ALUOp;
	
	output reg [1:0] FPUControl;
	output reg ResSrc;
	output reg [1:0] FPUFlagW;
	input wire [3:0] MulOp;
	output reg MulWrite;

	// Main FSM
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);

	// ADD CODE BELOW
	// Add code for the ALU Decoder and PC Logic.
	// Remember, you may reuse code from previous labs.
	// ALU Decoder
	always @(*) begin
		if (ALUOp) begin
			if (Op == 2'b00) begin
				//Operación ALU
				if (MulOp == 4'b1001) begin
					case (Funct[3:1])
						3'b000: begin
							ALUControl = 3'b100;
							MulWrite = 1'b0;
						end
						3'b100: begin
							ALUControl = 3'b101;
							MulWrite = 1'b1;
						end
						3'b110: begin
							ALUControl = 3'b110;
							MulWrite = 1'b1;
						end					
						default: begin
							ALUControl = 3'bxxx;
							MulWrite = 1'b0;
						end
					endcase
				end
				else begin
					case (Funct[4:1])
						4'b0100: ALUControl = 3'b000;
						4'b0010: ALUControl = 3'b001;
						4'b0000: ALUControl = 3'b010;
						4'b1100: ALUControl = 3'b011;
						default: ALUControl = 3'bxxx;
					endcase
					MulWrite = 1'b0;
				end
				
				FlagW[1] = Funct[0];
				FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
				
				ResSrc = 1'b0;
				FPUControl = 2'b00;
				FPUFlagW = 2'b00;
			end
			else if (Op == 2'b11) begin
				//Operación FPU (siempre con registros)
				case (Funct[4:1])
					4'b0000: FPUControl = 2'b00;
					4'b0001: FPUControl = 2'b01;
					4'b0010: FPUControl = 2'b10;
					4'b0011: FPUControl = 2'b11;
					default: FPUControl = 2'bxx;
				endcase
				FPUFlagW[1] = Funct[0];
				FPUFlagW[0] = 1'b0;
				
				ResSrc = 1'b1;
				ALUControl = 3'b000;
				FlagW = 2'b00;
				MulWrite = 1'b0;
			end
			else begin
				//Default
				ALUControl = 3'b000;
				FlagW = 2'b00;
				FPUControl = 2'b00;
				FPUFlagW = 2'b00;
				ResSrc = 1'b0;
				MulWrite = 1'b0;
			end
		end
		else begin
			//Default
			ALUControl = 3'b000;
			FlagW = 2'b00;
			FPUControl = 2'b00;
			FPUFlagW = 2'b00;
			ResSrc = 1'b0;
			MulWrite = 1'b0;
		end
	end
		
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

	// Add code for the Instruction Decoder (Instr Decoder) below.
	// Recall that the input to Instr Decoder is Op, and the outputs are
	// ImmSrc and RegSrc. We've completed the ImmSrc l4ogic for you.

	// Instr Decoder
	assign ImmSrc = Op;
	assign RegSrc[1] = Op == 2'b01;
	assign RegSrc[0] = Op == 2'b10;
endmodule
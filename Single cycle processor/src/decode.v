module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	FPUControl,
	ResSrc,
	FPUFlagW
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [1:0] ALUControl;
	output reg [1:0] FPUControl;
	output wire ResSrc;
	output reg [1:0] FPUFlagW;
	reg [10:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 11'b00001010010;
				else
					controls = 11'b00000010010;
			2'b01:
				if (Funct[0])
					controls = 11'b00011110000;
				else
					controls = 11'b10011101000;
			2'b10: controls = 11'b01101000100;
			2'b11: controls = 11'b00000010001;
			default: controls = 11'bxxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, ResSrc} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 2'b00;
				4'b0010: ALUControl = 2'b01;
				4'b0000: ALUControl = 2'b10;
				4'b1100: ALUControl = 2'b11;
				default: ALUControl = 2'bxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
		end
		else begin
			ALUControl = 2'b00;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
	
	always @(*)
		if (ResSrc) begin
			case (Funct[4:1])
				4'b0000: FPUControl = 2'b00;
				4'b0001: FPUControl = 2'b01;
				4'b0010: FPUControl = 2'b10;
				4'b0011: FPUControl = 2'b11;
				default: FPUControl = 2'bxx;
			endcase
			FPUFlagW[1] = Funct[0];
			FPUFlagW[0] = 1'b0;
		end
		else begin
			FPUControl = 2'b00;
			FPUFlagW = 2'b00;
		end
endmodule
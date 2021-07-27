module decode (
	Op,
	Funct,
	Rd,
	MulOp,
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
	FPUFlagW,
	FlagSrc
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire [7:4] MulOp;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
<<<<<<< HEAD
	output reg [2:0] ALUControl;
	reg [9:0] controls;
=======
	output reg [1:0] ALUControl;
	output reg [1:0] FPUControl;
	output wire ResSrc;
	output reg [1:0] FPUFlagW;
	output wire FlagSrc;
	reg [12:0] controls;
>>>>>>> 92fdea725afd55d394f43f0698b57fc4dbb46b38
	wire Branch;
	wire ALUOp;
	wire FPUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 13'b0000101001010;
				else
					controls = 13'b0000001001010;
			2'b01:
				if (Funct[0])
					controls = 13'b0001111000010;
				else
					controls = 13'b1001110100010;
			2'b10: controls = 13'b0110100010010;
			2'b11: controls = 13'b0000001000101;
			default: controls = 13'bxxxxxxxxxxxxx;
		endcase
<<<<<<< HEAD
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	
=======
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, FPUOp, ResSrc, FlagSrc} = controls;
>>>>>>> 92fdea725afd55d394f43f0698b57fc4dbb46b38
	always @(*)
		if (ALUOp) begin
			if (MulOp == 4'b1001) begin
				case (Funct[3:1])
					3'b000: ALUControl = 3'100;
					3'b100: ALUControl = 3'b101;
					3'b110: ALUControl = 3'b110;
					default: ALUControl = 3'bxxx;
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
			end
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
		end
		else begin
			ALUControl = 3'b000;
			FlagW = 2'b00;
		end
		
	
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
<<<<<<< HEAD

=======
	always @(*)
		if (FPUOp) begin
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
>>>>>>> 92fdea725afd55d394f43f0698b57fc4dbb46b38
endmodule
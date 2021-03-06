module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	initial $readmemh("memfile.asm", RAM);
	//initial $readmemh("memfile2.asm", RAM);
	//initial $readmemh("memfileFactorial.asm", RAM);
	//initial $readmemh("memfileSuma2n.asm", RAM);
	assign rd = RAM[a[31:2]];
endmodule
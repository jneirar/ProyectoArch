module mem (
	clk,
	we,
	a,
	wd,
	rd
);
	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	initial $readmemh("memfile.asm", RAM);
	//initial $readmemh("memfile2.asm", RAM);
	//initial $readmemh("memfileFactorial.asm", RAM);
	//initial $readmemh("memfileSuma2n.asm", RAM);
	assign rd = RAM[a[31:2]]; // word aligned
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule
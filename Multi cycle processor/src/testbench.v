module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
	reg [31:0] cycle;
	arm_multi dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.Adr(Adr),
		.MemWrite(MemWrite)
	);
	initial begin
		reset <= 1;
		cycle = 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		if (~reset)
			cycle = cycle + 1;
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
	always @(negedge clk)
		if (MemWrite)
			if ((Adr === 100) & (WriteData === 7)) begin
				$display("Simulation succeeded");
				#20;
				$finish;
			end
			else if (Adr !== 96) begin
				$display("Simulation failed");
				#20;
				$finish;
			end
	initial begin
		$dumpfile("arm_multi.vcd");
		$dumpvars;
	end
endmodule
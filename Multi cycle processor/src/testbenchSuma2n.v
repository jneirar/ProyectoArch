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
		if (MemWrite) begin
			if (Adr === 200) begin
				//if (WriteData === 32'h3f800000) begin	//i=1 //Línea 15 de código E2803001 //Cambiar mem
				//if (WriteData === 32'h3fc00000) begin	//i=2 //Línea 15 de código E2803002 //Cambiar mem
				if (WriteData === 32'h3fe00000) begin	//i=3 //Línea 15 de código E2803003 //Cambiar mem
				//if (WriteData === 32'h3ff00000) begin	//i=4 //Línea 15 de código E2803004 //Cambiar mem
				//if (WriteData === 32'h3ff80000) begin	//i=5 //Línea 15 de código E2803005 //Cambiar mem
				//if (WriteData === 32'h3ffc0000) begin	//i=6 //Línea 15 de código E2803006 //Cambiar mem
					$display("Simulation succeeded");
					#20;
					$finish;	
				end
				else begin
					$display("Simulation failed");
					$display("%h", WriteData);
					#20;
					$finish;
				end
			end
		end
	initial begin
		$dumpfile("arm_multi.vcd");
		$dumpvars;
	end
endmodule
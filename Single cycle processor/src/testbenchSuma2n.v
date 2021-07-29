module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.DataAdr(DataAdr),
		.MemWrite(MemWrite)
	);
	initial begin
		reset <= 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
	
	always @(negedge clk)
		if (MemWrite) begin
			if (DataAdr === 200) begin
				//if (WriteData === 32'h3f800000) begin	//i=1
				//if (WriteData === 32'h3fc00000) begin	//i=2
				if (WriteData === 32'h3fe00000) begin	//i=3
				//if (WriteData === 32'h3ff00000) begin	//i=4
				//if (WriteData === 32'h3ff80000) begin	//i=5
				//if (WriteData === 32'h3ffc0000) begin	//i=6
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
		$dumpfile("top.vcd");
		$dumpvars;
	end
endmodule
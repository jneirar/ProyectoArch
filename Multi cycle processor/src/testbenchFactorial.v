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
		if (~reset) begin
			cycle = cycle + 1;
		end
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
	
	always @(negedge clk)
		if (MemWrite) begin
			case (Adr)
				100: begin
					if (WriteData !== 32'h06890000) begin
						$display("Simulation failed Factorial LSB");
						#10;
						$finish;				  
					end
					else begin
						$display("Simulation succeded Factorial LSB");
						#10;
					end
				end
				104: begin
					if (WriteData !== 32'h1B02B93) begin
						$display("Simulation failed Factorial MSB");
						#10;
						$finish;				  
					end
					else begin
						$display("Simulation succeded Factorial MSB");
						#10;
					end
				end
				108: begin
					if (WriteData !== 32'hE3730400) begin
						$display("Simulation failed Negative Factorial LSB");
						#10;
						$finish;				  
					end
					else begin
						$display("Simulation succeded Negative Factorial LSB");
						#10;
					end
				end
				112: begin
					if (WriteData !== 32'hFFFFFFFF) begin
						$display("Simulation failed Negative Factorial MSB");
						#10;
						$finish;  
					end
					else begin
						$display("Simulation succeded Negative Factorial MSB ");
						#10;
						$finish;
					end
				end
			endcase
		end
	initial begin
		$dumpfile("arm_multi.vcd");
		$dumpvars;
	end
endmodule
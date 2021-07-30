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
			case (DataAdr)
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
		$dumpfile("top.vcd");
		$dumpvars;
	end
endmodule
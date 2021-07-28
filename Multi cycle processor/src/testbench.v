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
			case (Adr)
				100: begin
					if (WriteData !== 32'h4585e600) begin
						$display("Simulation failed VADD");
						#20;
						$finish;
					end
				end
				104: begin
					if (WriteData !== 32'h45c8c700) begin
						$display("Simulation failed VMUL");
						#20;
						$finish;
					end
				end
				108: begin
					if (WriteData !== 32'h00004040) begin
						$display("Simulation failed VADDH");
						#20;
						$finish;
					end
				end
				112: begin
					if (WriteData !== 32'h00003A80) begin
						$display("Simulation failed VMULH");
						#20;
						$finish;
					end
					else begin
						$display("Simulation succeeded");
						#20;
						$finish;
					end
				end
				default: begin
				  	$display("Simulation failed default");
					#20;
					$finish;
				end
			endcase
		end
	initial begin
		$dumpfile("arm_multi.vcd");
		$dumpvars;
	end
endmodule
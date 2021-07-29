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
		//#300;
		//$finish;
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
		/*if (MemWrite)
			if ((Adr === 100) & (WriteData === 7)) begin
				$display("Simulation succeeded");
				#20;
				$finish;
			end
			else if (Adr !== 96) begin
				$display("Simulation failed");
				#20;
				$finish;
			end*/
		/*	
		if (MemWrite) begin
			case (DataAdr)
				200: begin
					if (WriteData !== 32'h4585e600) begin
						$display("Simulation failed VADD");
						#20;
						$finish;
					end
				end
				204: begin
					if (WriteData !== 32'h45c8c700) begin
						$display("Simulation failed VMUL");
						#20;
						$finish;
					end
				end
				208: begin
					if (WriteData !== 32'h9C66BC00) begin
						$display("Simulation failed UMULL 1");
						#20;
						$finish;
					end
				end
				212: begin
					if (WriteData !== 32'h40000000) begin
						$display("Simulation failed UMULL 2");
						#20;
						$finish;
					end
				end
				216: begin
					if (WriteData !== 32'hBCC6700) begin
						$display("Simulation failed SMULL 1");
						#20;
						$finish;
					end
				end
				220: begin
					if (WriteData !== 32'h40000000) begin
						$display("Simulation failed SMULL 2");
						#20;
						$finish;
					end
				end
				224: begin
					if (WriteData !== 32'h00004040) begin
						$display("Simulation failed VADDH");
						#20;
						$finish;
					end
				end
				228: begin
					if (WriteData !== 32'h00003A80) begin
						$display("Simulation failed VMULH");
						#20;
						$finish;
					end
				end
				232: begin
					if (WriteData === 32'h8) begin
						$display("Simulation failed VADDS");
						#20;
						$finish;
					end
					else if (WriteData === 32'b0) begin
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
		*/
		if (MemWrite) begin
			case (DataAdr)
				100: begin
					if (WriteData != 32'h06890000) begin
						$display("Simulation failed LSB", WriteData);
						#20;
						$finish;				  
					end
				end
				104: begin
					if (WriteData != 32'h01B02B93) begin
						$display("Simulation failed MSB", WriteData);
						#20;
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
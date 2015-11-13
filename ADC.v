module ADC(in_slave, out_slave, out, cs, sclk, reset, clk, write, PM, add, shadow, seq);
`timescale 1 ns / 1 ps
	parameter DIGITS = 8; // 8 for AD7908
	input in_slave;
	input reset;
	input clk;
	input [2:0] add;
	input shadow;
	input seq;
	input [1:0] PM;
	output reg out_slave; 
	output reg cs;
	output reg sclk; 
	output reg write;
	output reg [DIGITS-1:0] out;
	reg buff;
	
	task perform_rw;
	input data_to_send;
	output reg dest;
	begin
		#1 out_slave <= data_to_send;
		@(out_slave == data_to_send) begin
			sclk <= 1;
		end
		@(posedge sclk) begin
			dest <= in_slave; 
			#1 sclk <= 0;
		end
	end
	endtask
	
	always @(posedge clk) begin
		if (reset) begin
			out_slave <= 0;
			cs <= 1;
			sclk <= 0;
			write <= 0;
			out <= 0;
			buff <= 0;
		end
		else begin
			cs <= 0;
			#1 sclk <= 0;
		end
	end
	
endmodule

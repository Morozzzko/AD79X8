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
		#3 sclk <= 1;
		#5 dest <= in_slave; 
		#6 sclk <= 0;
	end
	endtask
	
	always @(posedge clk) begin
		cs <= 0;
		#1 sclk <= 0;
		#2 perform_rw(write, buff);
	end
	
endmodule

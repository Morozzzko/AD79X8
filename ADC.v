module ADC(in_slave, out_slave, out, cs, sclk, reset, clk, PM, add, shadow, seq);
	parameter DIGITS = 8; // 8 for AD7908
	input in_slave;
	input reset;
	input clk;
	input [2:0] add;
	input shadow;
	input seq;
	input [1:0] PM;
	output out_slave; 
	output cs;
	output sclk; 
	output [DIGITS-1:0] out;
	
endmodule

module ADC(d_in, d_out, in, out, sclk, cs, initiate, clk);
`timescale 100 ps / 1 ps

	// the clk is intended to have the same frequency as sclk
	// although there must be a phase shift
	
	input d_in;
	input [15:0] in;
	input initiate; // signal to initiate the transaction
	input clk;
	
	output sclk;
	output d_out;
	output reg [15:0] out = 16'b0;
	output reg cs = 1'b1;
	
	assign sclk = (~cs) & (~clk) | initiate & cs & clk;
	
	reg [3:0] count = 4'b1111;
	reg [15:0] RgIn = 16'b0;
	
	assign d_out = RgIn[15];
	
	always @(posedge clk) begin
		if (initiate && cs) begin
			RgIn <= in;
			cs <= 1'b0;
		end
		else begin 
			RgIn <= RgIn << 1;
		end
		if (count == 4'b0000) begin
			cs <= 1'b1;
		end
	end
	
	always @(negedge sclk) begin
		out[count] <= d_in;
		if (count == 4'b0000) begin
			count <= 4'b1111;
		end
		else begin
			count <= count - 1'b1;
		end
	end
	
	
	
endmodule

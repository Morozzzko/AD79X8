module ADC(serial_in, serial_out, bus_in, bus_out, sclk, cs, initiate, clk, ready);
`timescale 100 ps / 1 ps

	// the clk is intended to have the same frequency as sclk
	// although there must be a phase shift
	
	input serial_in;
	input [15:0] bus_in;
	input initiate; // signal to initiate the transaction
	input clk;
	
	output ready;
	output sclk;
	output serial_out;
	output reg [15:0] bus_out = 16'b0;
	output reg cs = 1'b1;
	
	assign sclk = (~cs) & (~clk) | cs;
	assign ready = cs;
	
	reg [3:0] count = 4'b1111;
	reg [15:0] RgIn = 16'b0;
	
	assign serial_out = RgIn[15];
	
	initial begin
		bus_out <= 16'b0;
	end
	
	always @(posedge clk) begin
		if (initiate && cs) begin
			RgIn <= bus_in;
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
		bus_out[count] <= serial_in;
		if (count == 4'b0000) begin
			count <= 4'b1111;
		end
		else begin
			count <= count - 1'b1;
		end
	end
	
	
	
endmodule

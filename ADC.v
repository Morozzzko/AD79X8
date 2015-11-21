`timescale 100 ps / 1 ps
module ADC(serial_in, serial_out, bus_in, bus_out, sclk, cs, initiate, clk, ready);
    // A simple SPI interface for AD7908/AD7918/AD7928 Analog-to-digital converters 
    input serial_in; // serial input from ADC 
    input [15:0] bus_in; // bus data to be sent to ADC 
    input initiate; // if set to "1", the module will initiate transfer on the next active clock
    input clk; // module is active on clk rising edge. used to manipulate data and generate sclk for the ADC

    output ready; // is set to "1" when the conversion is done; or when the 
    output sclk; // serial clock for the ADCs. active on falling edge
    output serial_out; // serial output to ADC 
    output reg [15:0] bus_out = 16'b0; // data read from ADCs
    output reg cs = 1'b1; // chip select for ADC

    assign sclk = (~cs) & (~clk) | cs; 
    assign ready = cs;
    assign serial_out = RgIn[15];
 
    reg [3:0] count = 4'b1111;
    reg [15:0] RgIn = 16'b0;
     
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

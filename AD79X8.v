`timescale 100 ps / 1 ps
module AD79X8(serial_in, serial_out, bus_in, bus_out, sclk, cs, initiate, clk, ready, reset);
    // A simple SPI interface for AD7908/AD7918/AD7928 Analog-to-digital converters 
    
    parameter clk_division = 10; // a parameter for the clock divider. must be an even number
    parameter clk_digits = 4; // parameter for the clock divider. represents
    // the number of digits required to store clk_division 

    input serial_in; // serial input from ADC 
    input [15:0] bus_in; // bus data to be sent to ADC 
    input initiate; // if set to "1", the module will initiate transfer on the next active clock
    input clk; // module is active on clk rising edge. used to manipulate data and generate sclk for the ADC
    input reset; // if set to "1", the registers will reset on the next clk rising edge.
    // reset won't work if 'ready' is not active

    output ready; // is set to "1" when the conversion is done; or when the 
    output reg sclk = 1'b1; // serial clock for the ADCs. active on falling edge
    output serial_out; // serial output to ADC 
    output reg [15:0] bus_out = 16'b0; // data read from ADCs
    output reg cs = 1'b1; // chip select for ADC
  
    assign ready = cs;
    assign serial_out = RgIn[15];
 
    reg [3:0] count = 4'b1111;
    reg [15:0] RgIn = 16'b0;
    
    reg [clk_digits:0] clk_counter = 0;
    
    // sclk generation 
    // begins when the transaction is initialized
    // goes on while the module is not 'ready'
    always @(posedge clk) begin
        if (ready && reset) begin
            clk_counter = 0;
        end
        else if (~ready || initiate) begin 
            clk_counter = clk_counter + 1;
            if (clk_counter == 1) begin
                sclk <= 1'b1;
            end
            else if (clk_counter == clk_division) begin
                clk_counter <= 0;
                sclk <= 1'b0;
            end
        end
    end
     
    // module to ADC
    always @(posedge clk) begin
        if (reset && ready) begin
            cs <= 1'b1;
        end
        else begin
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
    end
    
    // ADC to module
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

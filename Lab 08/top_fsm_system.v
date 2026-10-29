`timescale 1ns/1ps 
 
module top_fsm_system ( 
    input wire clk, 
    input wire pbin, 
    input wire [15:0] physical_sw, 
    output wire [15:0] physical_leds 
); 
 
    wire rst; 
    debouncer db (.clk(clk), .pbin(pbin), .pbout(rst)); 
	wire MemWrite = physical_sw[15]; //out of indent, can't format this in notepad
    wire MemRead = ~physical_sw[15]; 
 
    wire [31:0] address = {22'd0, physical_sw[14:5]}; 
    wire [31:0] writeData = {27'd0, physical_sw[4:0]}; 
 
    wire [31:0] readData; 
    wire [15:0] mem_mapped_leds; 
 
    // Positional instantiation for addressDecoderTop (Order: clk, rst, address, 
readEnable, writeEnable, writeData, switches, readData, leds) 
    addressDecoderTop uut ( 
        clk, 
        rst, 
        address, 
        MemRead, 
        MemWrite, 
        writeData, 
        {11'd0, physical_sw[4:0]}, 
        readData, 
        mem_mapped_leds 
    ); 
    assign physical_leds = (physical_sw[14:13] == 2'b10) ? mem_mapped_leds : 
readData[15:0]; 
 
endmodule 
`timescale 1ns / 1ps 
module MemorySystem_tb; 
 
    reg clk, rst; 
    reg [31:0] address; 
    reg readEnable, writeEnable; 
    reg [31:0] writeData; 
    reg [15:0] physical_switches; 
 
    wire [31:0] readData; 
    wire [15:0] physical_leds; 
 
    addressDecoderTop uut ( 
        .clk(clk), 
        .rst(rst), 
        .address(address), 
        .readEnable(readEnable), 
        .writeEnable(writeEnable), 
        .writeData(writeData), 
        .physical_switches(physical_switches), 
        .readData(readData), 
        .physical_leds(physical_leds) 
    ); 
 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1; address = 0; 
        readEnable = 0; writeEnable = 0; writeData = 0;  
        physical_switches = 16'hA5A5;  
         
        #10 rst = 0; 
 
        #10 address = 32'h0000_0004; writeData = 32'hDEADBEEF; writeEnable = 1; 
        #10 writeEnable = 0; 
 
        #10 address = 32'h0000_0100; writeData = 32'h0000_FFFF; writeEnable = 1; 
        #10 writeEnable = 0; 
 
        #10 address = 32'h0000_0004; readEnable = 1; 
        #10 readEnable = 0; 
 
        #10 address = 32'h0000_0200; readEnable = 1;
	 #10 readEnable = 0; 
 
        #20 $finish; 
    end 
endmodule 
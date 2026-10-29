`timescale 1ns / 1ps 
 
module addressDecoderTop( 
    input clk, rst, 
    input [31:0] address, 
    input readEnable, writeEnable, 
    input [31:0] writeData, 
    input [15:0] physical_switches, 
 
    output [31:0] readData, 
    output [15:0] physical_leds 
); 
 
    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable; 
    wire [31:0] dataMemOut, switchOut; 
 
    AddressDecoder decoder ( 
        .address(address[9:8]), 
        .readEnable(readEnable), 
        .writeEnable(writeEnable), 
        .DataMemWrite(DataMemWrite), 
        .DataMemRead(DataMemRead), 
        .LEDWrite(LEDWrite), 
        .SwitchReadEnable(SwitchReadEnable) 
    ); 
 
    DataMemory dmem ( 
        .clk(clk), 
        .MemWrite(DataMemWrite), 
        .address(address[8:0]),  
        .write_data(writeData), 
        .read_data(dataMemOut) 
    ); 
 
    switches led_writer ( 
        .clk(clk), 
        .rst(rst), 
        .writeData(writeData), 
        .writeEnable(LEDWrite), 
        .readEnable(1'b0), 
        .memAddress(address[29:0]), 
        .readData(), 
        .leds(physical_leds) 
    ); 
 
    leds switch_reader (
	 .clk(clk), 
        .rst(rst), 
        .btns(16'd0), 
        .writeData(32'd0), 
        .writeEnable(1'b0), 
        .readEnable(SwitchReadEnable), 
        .memAddress(address[29:0]), 
        .switches(physical_switches), 
        .readData(switchOut) 
    ); 
 
    assign readData = (address[9:8] == 2'b00) ? dataMemOut : 
                      (address[9:8] == 2'b10) ? switchOut : 32'd0; 
 
endmodule 
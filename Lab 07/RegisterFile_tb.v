`timescale 1ns / 1ps 
module RegisterFile_tb; 
 
reg clk = 0, rst = 1, WriteEnable = 0; 
reg [4:0] rs1 = 0, rs2 = 0, rd = 0; 
reg [31:0] WriteData = 0; 
wire [31:0] ReadData1, ReadData2; 
 
RegisterFile dut( 
    .clk(clk), .rst(rst), .WriteEnable(WriteEnable), 
    .rs1(rs1), .rs2(rs2), .rd(rd), 
    .WriteData(WriteData), 
    .ReadData1(ReadData1), .ReadData2(ReadData2) 
); 
 
always #5 clk = ~clk; 
 
initial begin 
    #10 rst = 0; 
 
    WriteEnable = 1; rd = 5; WriteData = 10; 
    #10 rd = 6; WriteData = 20; 
    #10 WriteEnable = 0; rs1 = 5; rs2 = 6; 
 
    #10 WriteEnable = 1; rd = 0; WriteData = 30; rs1 = 0; 
    #10 rd = 5; WriteData = 40; 
    #10 WriteEnable = 0; rs1 = 5; 
 
    #10 rst = 1; 
    #10 rst = 0; 
    #10 $finish; 
end 
 
endmodule 
Register File: 
`timescale 1ns / 1ps 
 
`timescale 1ns / 1ps 
 
module RegisterFile( 
    input clk, rst, WriteEnable, 
    input [4:0] rs1, rs2, rd, 
    input [31:0] WriteData, 
    output [31:0] ReadData1, ReadData2 
); 
 
reg [31:0] regs [31:0]; 
integer i; 
 
always @(posedge clk) begin 
    if (rst) 
        for (i = 0; i < 32; i = i + 1) 
            regs[i] <= 0; 
    else if (WriteEnable && rd != 0) 
        regs[rd] <= WriteData; 
end 
 
assign ReadData1 = (rs1 == 0) ? 0 : regs[rs1]; 
assign ReadData2 = (rs2 == 0) ? 0 : regs[rs2]; 
 
endmodule 
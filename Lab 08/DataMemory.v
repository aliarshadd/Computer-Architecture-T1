DataMemory: (Stores data words): 
`timescale 1ns / 1ps 
module DataMemory ( 
    input clk, 
    input MemWrite, 
    input [8:0] address,  
    input [31:0] write_data, 
    output [31:0] read_data 
); 
    reg [31:0] memory [0:511]; 
    assign read_data = memory[address]; 
    always @(posedge clk) begin 
        if (MemWrite) begin 
            memory[address] <= write_data; 
        end 
    end 
endmodule 
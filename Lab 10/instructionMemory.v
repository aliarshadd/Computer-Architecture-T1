`timescale 1ns / 1ps 
////////////////////////////////////////////////////////////////////////////////// 
// Company:  
// Engineer:  
//  
// Create Date: 10/29/2026 09:51:13 PM 
// Design Name:  
// Module Name: instructionMemory 
// Project Name:  
// Target Devices:  
// Tool Versions:  
// Description:  
//  
// Dependencies:  
//  
// Revision: 
// Revision 0.01 - File Created 
// Additional Comments: 
//  
////////////////////////////////////////////////////////////////////////////////// 
module instructionMemory#( 
    parameter OPERAND_LENGTH = 31 
)( 
    input [OPERAND_LENGTH:0] instAddress, 
    output reg [31:0] instruction 
); 
 
    reg [7:0] memory [0:255]; 
 
    initial begin 
        $readmemh("lab10.mem", memory); 
    end 
 
    always @(*) begin 
        instruction = { 
            memory[instAddress + 3], 
            memory[instAddress + 2], 
            memory[instAddress + 1], 
            memory[instAddress] 
        }; 
    end 
 
endmodule

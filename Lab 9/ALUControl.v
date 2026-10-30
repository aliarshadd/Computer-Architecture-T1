`timescale 1ns / 1ps
module ALUControl (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00:   ALUControl = 4'b0010;          // loads/stores/ADDI -> ADD
            2'b01:   ALUControl = 4'b0111;          // BEQ
            2'b10: begin                            // R-type
                case (funct3)
                    3'b000:  ALUControl = (funct7[5]) ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b001:  ALUControl = 4'b0100;  // SLL
                    3'b101:  ALUControl = 4'b0101;  // SRL
                    3'b111:  ALUControl = 4'b0000;  // AND
                    3'b110:  ALUControl = 4'b0001;  // OR
                    3'b100:  ALUControl = 4'b0011;  // XOR
                    default: ALUControl = 4'b0010;  // safe default
                endcase
            end
            default: ALUControl = 4'b0010;
        endcase
    end
endmodule

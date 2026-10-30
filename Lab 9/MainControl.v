`timescale 1ns / 1ps
module MainControl (
    input  [6:0] opcode,
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       Branch,
    output reg [1:0] ALUOp
);
    localparam OP_RTYPE  = 7'b0110011;  // ADD SUB SLL SRL AND OR XOR
    localparam OP_ITYPE  = 7'b0010011;  // ADDI
    localparam OP_LOAD   = 7'b0000011;  // LW LH LB
    localparam OP_STORE  = 7'b0100011;  // SW SH SB
    localparam OP_BRANCH = 7'b1100011;  // BEQ

    always @(*) begin
        // safe defaults (no write, no memory access, no branch)
        RegWrite = 1'b0; ALUSrc = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
        MemtoReg = 1'b0; Branch  = 1'b0; ALUOp   = 2'b00;
        case (opcode)
            OP_RTYPE:  begin RegWrite = 1; ALUOp = 2'b10; end
            OP_ITYPE:  begin RegWrite = 1; ALUSrc = 1; ALUOp = 2'b00; end
            OP_LOAD:   begin RegWrite = 1; ALUSrc = 1; MemRead = 1; MemtoReg = 1; ALUOp = 2'b00; end
            OP_STORE:  begin ALUSrc = 1; MemWrite = 1; ALUOp = 2'b00; end
            OP_BRANCH: begin Branch = 1; ALUOp = 2'b01; end
            default: ;
        endcase
    end
endmodule

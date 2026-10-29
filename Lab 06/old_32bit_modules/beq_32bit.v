`timescale 1ns / 1ps
// Equal = 1 when all 32 bit-pairs match
module beq_32bit (input [31:0] A, B, output Equal);
    wire [31:0] eq;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : g
            beq_1bit u (.a(A[i]), .b(B[i]), .eq(eq[i]));
        end
    endgenerate
    assign Equal = &eq;
endmodule

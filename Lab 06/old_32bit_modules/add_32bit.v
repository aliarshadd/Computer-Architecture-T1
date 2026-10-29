`timescale 1ns / 1ps
// 32-bit ripple-carry adder built from 32 full adders
module add_32bit (input [31:0] A, B, output [31:0] Sum, output Cout);
    wire [32:0] c;
    assign c[0] = 1'b0;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : g
            add_1bit u (.a(A[i]), .b(B[i]), .cin(c[i]), .sum(Sum[i]), .cout(c[i+1]));
        end
    endgenerate
    assign Cout = c[32];
endmodule

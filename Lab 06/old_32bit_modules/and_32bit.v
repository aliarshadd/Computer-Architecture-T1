`timescale 1ns / 1ps
module and_32bit (input [31:0] A, B, output [31:0] Y);
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : g
            and_1bit u (.a(A[i]), .b(B[i]), .y(Y[i]));
        end
    endgenerate
endmodule

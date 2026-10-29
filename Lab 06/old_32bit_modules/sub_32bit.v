`timescale 1ns / 1ps
// 32-bit ripple-borrow subtractor built from 32 full subtractors
module sub_32bit (input [31:0] A, B, output [31:0] Diff, output Bout);
    wire [32:0] br;
    assign br[0] = 1'b0;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : g
            sub_1bit u (.a(A[i]), .b(B[i]), .bin(br[i]), .diff(Diff[i]), .bout(br[i+1]));
        end
    endgenerate
    assign Bout = br[32];
endmodule

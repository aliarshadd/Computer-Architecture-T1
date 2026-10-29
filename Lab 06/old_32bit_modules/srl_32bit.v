`timescale 1ns / 1ps
// Barrel shifter: 5 stages (shift by 1,2,4,8,16) of 32 srl_1bit cells
module srl_32bit (input [31:0] A, input [4:0] shamt, output [31:0] Y);
    wire [31:0] stage [0:5];
    assign stage[0] = A;
    genvar k, i;
    generate
        for (k = 0; k < 5; k = k + 1) begin : stg
            for (i = 0; i < 32; i = i + 1) begin : col
                if (i + (1 << k) < 32) begin : sh
                    srl_1bit u (.a(stage[k][i]), .a_from(stage[k][i + (1 << k)]),
                                .en(shamt[k]), .y(stage[k+1][i]));
                end else begin : zf
                    srl_1bit u (.a(stage[k][i]), .a_from(1'b0),
                                .en(shamt[k]), .y(stage[k+1][i]));
                end
            end
        end
    endgenerate
    assign Y = stage[5];
endmodule

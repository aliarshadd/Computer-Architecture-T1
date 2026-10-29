`timescale 1ns / 1ps
// Full subtractor: diff = a - b - bin
module sub_1bit (input a, b, bin, output diff, bout);
    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | (~(a ^ b) & bin);
endmodule

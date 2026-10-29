`timescale 1ns / 1ps
// Shift-right cell: takes the bit from the higher position when en = 1
module srl_1bit (input a, a_from, en, output y);
    assign y = en ? a_from : a;
endmodule

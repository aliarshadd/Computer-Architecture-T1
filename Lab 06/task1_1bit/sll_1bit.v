`timescale 1ns / 1ps
// Shift-left cell: takes the bit from the lower position when en = 1
module sll_1bit (input a, a_from, en, output y);
    assign y = en ? a_from : a;
endmodule

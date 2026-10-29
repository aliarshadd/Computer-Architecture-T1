`timescale 1ns / 1ps
// Full adder
module add_1bit (input a, b, cin, output sum, cout);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

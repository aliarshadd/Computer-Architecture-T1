`timescale 1ns / 1ps
// Bit-equal: eq = 1 when a == b (XNOR)
module beq_1bit (input a, b, output eq);
    assign eq = ~(a ^ b);
endmodule

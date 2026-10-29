`timescale 1ns / 1ps
// Task 1: 1-bit ALU (top) - calls one module per operation
// ALUControl: 0000 AND | 0001 OR | 0010 ADD | 0110 SUB
//             0011 XOR | 0100 SLL | 0101 SRL | 0111 BEQ
module alu_1bit (
    input        a, b,
    input        cin,            // carry-in (ADD) / borrow-in (SUB, BEQ)
    input        a_left,         // a[i-1], used by SLL
    input        a_right,        // a[i+1], used by SRL
    input  [3:0] ALUControl,
    output reg   result,
    output reg   cout,           // carry-out (ADD) / borrow-out (SUB, BEQ)
    output       eq              // bit-equal flag for BEQ
);
    wire and_y, or_y, xor_y, add_s, add_c, sub_d, sub_b, sll_y, srl_y;

    and_1bit u_and (.a(a), .b(b), .y(and_y));
    or_1bit  u_or  (.a(a), .b(b), .y(or_y));
    xor_1bit u_xor (.a(a), .b(b), .y(xor_y));
    add_1bit u_add (.a(a), .b(b), .cin(cin), .sum(add_s), .cout(add_c));
    sub_1bit u_sub (.a(a), .b(b), .bin(cin), .diff(sub_d), .bout(sub_b));
    sll_1bit u_sll (.a(a), .a_from(a_left),  .en(1'b1), .y(sll_y));
    srl_1bit u_srl (.a(a), .a_from(a_right), .en(1'b1), .y(srl_y));
    beq_1bit u_beq (.a(a), .b(b), .eq(eq));

    always @(*) begin
        cout = 1'b0;
        case (ALUControl)
            4'b0000: result = and_y;
            4'b0001: result = or_y;
            4'b0010: begin result = add_s; cout = add_c; end
            4'b0110: begin result = sub_d; cout = sub_b; end
            4'b0011: result = xor_y;
            4'b0100: result = sll_y;
            4'b0101: result = srl_y;
            4'b0111: begin result = sub_d; cout = sub_b; end  // BEQ
            default: result = 1'b0;
        endcase
    end
endmodule

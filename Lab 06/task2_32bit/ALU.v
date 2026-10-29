`timescale 1ns / 1ps
// Task 2: 32-bit ALU (top) - built by iterating the Task 1 one-bit modules
// ALUControl: 0000 AND | 0001 OR | 0010 ADD | 0110 SUB
//             0011 XOR | 0100 SLL | 0101 SRL | 0111 BEQ
module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,
    output reg [31:0] ALUResult,
    output        Zero
);
    wire [31:0] and_y, or_y, xor_y, add_y, sub_y, eq_bits;
    wire [32:0] carry, borrow;
    wire [31:0] sll_st [0:5];
    wire [31:0] srl_st [0:5];

    assign carry[0]  = 1'b0;      // ADD carry-in
    assign borrow[0] = 1'b0;      // SUB borrow-in
    assign sll_st[0] = A;
    assign srl_st[0] = A;

    genvar i, k;

    // ---- Bitwise, ADD, SUB, BEQ: one 1-bit module per bit ----
    generate
        for (i = 0; i < 32; i = i + 1) begin : bitslice
            and_1bit u_and (.a(A[i]), .b(B[i]), .y(and_y[i]));
            or_1bit  u_or  (.a(A[i]), .b(B[i]), .y(or_y[i]));
            xor_1bit u_xor (.a(A[i]), .b(B[i]), .y(xor_y[i]));
            add_1bit u_add (.a(A[i]), .b(B[i]), .cin(carry[i]),
                            .sum(add_y[i]), .cout(carry[i+1]));
            sub_1bit u_sub (.a(A[i]), .b(B[i]), .bin(borrow[i]),
                            .diff(sub_y[i]), .bout(borrow[i+1]));
            beq_1bit u_beq (.a(A[i]), .b(B[i]), .eq(eq_bits[i]));
        end
    endgenerate

    // ---- SLL / SRL: 5 stages (shift by 1,2,4,8,16) of 1-bit shift cells ----
    generate
        for (k = 0; k < 5; k = k + 1) begin : stg
            for (i = 0; i < 32; i = i + 1) begin : col
                if (i >= (1 << k)) begin : sll_sh
                    sll_1bit u_sll (.a(sll_st[k][i]), .a_from(sll_st[k][i - (1 << k)]),
                                    .en(B[k]), .y(sll_st[k+1][i]));
                end else begin : sll_zf
                    sll_1bit u_sll (.a(sll_st[k][i]), .a_from(1'b0),
                                    .en(B[k]), .y(sll_st[k+1][i]));
                end
                if (i + (1 << k) < 32) begin : srl_sh
                    srl_1bit u_srl (.a(srl_st[k][i]), .a_from(srl_st[k][i + (1 << k)]),
                                    .en(B[k]), .y(srl_st[k+1][i]));
                end else begin : srl_zf
                    srl_1bit u_srl (.a(srl_st[k][i]), .a_from(1'b0),
                                    .en(B[k]), .y(srl_st[k+1][i]));
                end
            end
        end
    endgenerate

    wire beq_eq = &eq_bits;

    // ---- Operation select ----
    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = and_y;
            4'b0001: ALUResult = or_y;
            4'b0010: ALUResult = add_y;
            4'b0110: ALUResult = sub_y;
            4'b0011: ALUResult = xor_y;
            4'b0100: ALUResult = sll_st[5];
            4'b0101: ALUResult = srl_st[5];
            4'b0111: ALUResult = sub_y;      // BEQ: A - B
            default: ALUResult = 32'b0;
        endcase
    end

    // BEQ uses the equality bits; all other ops flag a zero result
    assign Zero = (ALUControl == 4'b0111) ? beq_eq : (ALUResult == 32'b0);
endmodule

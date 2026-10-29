`timescale 1ns / 1ps
module alu_1bit_tb;
    reg a, b, cin, al, ar; reg [3:0] ctrl;
    wire result, cout, eq;
    reg e_res, e_cout;
    integer n, j, errors = 0;
    reg [3:0] ops [0:7];

    alu_1bit dut (.a(a), .b(b), .cin(cin), .a_left(al), .a_right(ar),
                  .ALUControl(ctrl), .result(result), .cout(cout), .eq(eq));

    initial begin
        $dumpfile("alu_1bit_tb.vcd"); $dumpvars(0, alu_1bit_tb);
        ops[0]=4'b0000; ops[1]=4'b0001; ops[2]=4'b0010; ops[3]=4'b0110;
        ops[4]=4'b0011; ops[5]=4'b0100; ops[6]=4'b0101; ops[7]=4'b0111;
        for (j = 0; j < 8; j = j + 1)
            for (n = 0; n < 32; n = n + 1) begin
                {a, b, cin, al, ar} = n; ctrl = ops[j]; #5;
                e_cout = 0;
                case (ctrl)
                    4'b0000: e_res = a & b;
                    4'b0001: e_res = a | b;
                    4'b0010: begin e_res = a ^ b ^ cin; e_cout = (a & b) | (cin & (a ^ b)); end
                    4'b0110,
                    4'b0111: begin e_res = a ^ b ^ cin; e_cout = (~a & b) | (~(a ^ b) & cin); end
                    4'b0011: e_res = a ^ b;
                    4'b0100: e_res = al;
                    4'b0101: e_res = ar;
                    default: e_res = 0;
                endcase
                if (result !== e_res || cout !== e_cout || eq !== ~(a ^ b)) begin
                    errors = errors + 1;
                    $display("FAIL ctrl=%b a=%b b=%b cin=%b al=%b ar=%b", ctrl, a, b, cin, al, ar);
                end
            end
        if (errors == 0) $display("1-BIT ALU: ALL TESTS PASSED (256 vectors)");
        else $display("%0d FAILED", errors);
        $finish;
    end
endmodule

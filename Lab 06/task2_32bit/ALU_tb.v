`timescale 1ns / 1ps
module ALU_tb;
    reg  [31:0] A, B;
    reg  [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire        Zero;
    integer     errors = 0;

    ALU dut (.A(A), .B(B), .ALUControl(ALUControl),
             .ALUResult(ALUResult), .Zero(Zero));

    task check;
        input [3:0]  ctrl;
        input [31:0] a, b, exp_res;
        input        exp_zero;
        begin
            ALUControl = ctrl; A = a; B = b;
            #10;
            if (ALUResult !== exp_res || Zero !== exp_zero) begin
                errors = errors + 1;
                $display("FAIL ctrl=%b A=%h B=%h -> res=%h zero=%b (exp %h, %b)",
                         ctrl, a, b, ALUResult, Zero, exp_res, exp_zero);
            end else
                $display("PASS ctrl=%b A=%h B=%h -> res=%h zero=%b",
                         ctrl, a, b, ALUResult, Zero);
        end
    endtask

    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);

        // Lab operands: A = 0x10101010, B = 0x01010101
        check(4'b0010, 32'h10101010, 32'h01010101, 32'h11111111, 0); // ADD
        check(4'b0110, 32'h10101010, 32'h01010101, 32'h0F0F0F0F, 0); // SUB
        check(4'b0000, 32'h10101010, 32'h01010101, 32'h00000000, 1); // AND
        check(4'b0001, 32'h10101010, 32'h01010101, 32'h11111111, 0); // OR
        check(4'b0011, 32'h10101010, 32'h01010101, 32'h11111111, 0); // XOR
        check(4'b0100, 32'h10101010, 32'h01010101, 32'h20202020, 0); // SLL by 1
        check(4'b0101, 32'h10101010, 32'h01010101, 32'h08080808, 0); // SRL by 1

        // BEQ: Zero = 1 only when A == B
        check(4'b0111, 32'h00000005, 32'h00000005, 32'h00000000, 1); // equal
        check(4'b0111, 32'h00000005, 32'h00000006, 32'hFFFFFFFF, 0); // not equal

        // Corner cases
        check(4'b0010, 32'hFFFFFFFF, 32'h00000001, 32'h00000000, 1); // ADD wrap
        check(4'b0110, 32'h00000000, 32'h00000001, 32'hFFFFFFFF, 0); // SUB negative
        check(4'b0100, 32'h10101010, 32'h00000004, 32'h01010100, 0); // SLL by 4
        check(4'b0101, 32'h10101010, 32'h00000004, 32'h01010101, 0); // SRL by 4
        check(4'b0101, 32'h80000000, 32'h0000001F, 32'h00000001, 0); // SRL by 31
        check(4'b0100, 32'h00000001, 32'h0000001F, 32'h80000000, 0); // SLL by 31
        check(4'b0000, 32'hFFFF0000, 32'h0F0F0F0F, 32'h0F0F0000, 0); // AND
        check(4'b0011, 32'hAAAAAAAA, 32'hAAAAAAAA, 32'h00000000, 1); // XOR same

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule

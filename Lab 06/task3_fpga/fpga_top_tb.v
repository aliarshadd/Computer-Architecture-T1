`timescale 1ns / 1ps
module fpga_top_tb;
    reg clk = 0;
    reg [15:0] sw = 0;
    reg btnC = 0, btnU = 0, btnR = 0;
    wire [15:0] led;
    integer errors = 0;

    fpga_top #(.DB_CYCLES(4)) dut (.clk(clk), .sw(sw), .btnC(btnC), .btnU(btnU),
                                   .btnR(btnR), .led(led));
    always #5 clk = ~clk;

    task press_view; begin btnC = 1; repeat (20) @(posedge clk); btnC = 0; repeat (20) @(posedge clk); end endtask
    task press_op;   begin btnU = 1; repeat (20) @(posedge clk); btnU = 0; repeat (20) @(posedge clk); end endtask
    task expect_led; input [15:0] e; input [255:0] name;
        begin
            repeat (8) @(posedge clk);
            if (led !== e) begin errors = errors + 1; $display("FAIL %0s: led=%h exp=%h", name, led, e); end
            else $display("PASS %0s: led=%h", name, led);
        end
    endtask

    initial begin
        $dumpfile("fpga_top_tb.vcd"); $dumpvars(0, fpga_top_tb);
        btnR = 1; repeat (5) @(posedge clk); btnR = 0; repeat (5) @(posedge clk);

        // Manual mode: A = 0x10101010, B = 0x01010101
        sw = 16'h0002; expect_led(16'h1111, "ADD low");
        press_view;    expect_led(16'h1111, "ADD high");
        press_view;    expect_led(16'h2000, "ADD flags (ctrl=2, Zero=0)");
        press_view;
        sw = 16'h0006; expect_led(16'h0F0F, "SUB low");
        sw = 16'h0000; expect_led(16'h0000, "AND low");
        press_view; press_view; expect_led(16'h0001, "AND flags (Zero=1)");
        press_view;
        sw = 16'h0001; expect_led(16'h1111, "OR low");
        sw = 16'h0003; expect_led(16'h1111, "XOR low");
        sw = 16'h0004; expect_led(16'h2020, "SLL low");
        sw = 16'h0005; expect_led(16'h0808, "SRL low");
        sw = 16'h0007; expect_led(16'h0F0F, "BEQ low (A-B)");
        press_view; press_view; expect_led(16'h7000, "BEQ flags (A!=B, Zero=0)");
        press_view;

        // Auto mode: FSM steps ALUControl with btnU
        sw = 16'h8000; expect_led(16'h0000, "auto op0 AND");
        press_op;      expect_led(16'h1111, "auto op1 OR");
        press_op;      expect_led(16'h1111, "auto op2 ADD");
        press_op;      expect_led(16'h0F0F, "auto op3 SUB");
        press_op;      expect_led(16'h1111, "auto op4 XOR");
        press_op;      expect_led(16'h2020, "auto op5 SLL");
        press_op;      expect_led(16'h0808, "auto op6 SRL");
        press_op;      expect_led(16'h0F0F, "auto op7 BEQ");
        press_op;      expect_led(16'h0000, "auto wraps to AND");

        if (errors == 0) $display("FPGA TOP: ALL TESTS PASSED"); else $display("%0d FAILED", errors);
        $finish;
    end
endmodule

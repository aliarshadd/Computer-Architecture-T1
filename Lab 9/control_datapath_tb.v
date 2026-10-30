`timescale 1ns / 1ps
module control_datapath_tb;
    reg clk = 0, rst = 1, step = 0;
    reg [15:0] sw = 16'h0000;
    wire [15:0] led_data;
    integer i, errors = 0;

    control_datapath dut (.clk(clk), .rst(rst), .step(step), .sw(sw), .led_data(led_data));
    always #5 clk = ~clk;

    task do_step; begin step = 1; @(posedge clk); #1 step = 0; @(posedge clk); #1; end endtask
    task chk; input [31:0] got, exp; input [255:0] name;
        begin
            if (got !== exp) begin errors = errors + 1; $display("FAIL %0s: got %h exp %h", name, got, exp); end
            else $display("PASS %0s = %h", name, got);
        end
    endtask

    initial begin
        $dumpfile("control_datapath_tb.vcd"); $dumpvars(0, control_datapath_tb);
        for (i = 0; i < 512; i = i + 1) dut.memsys.dmem.memory[i] = 32'd0;   // FPGA memory powers up as 0
        repeat (3) @(posedge clk); #1 rst = 0;

        // ---- manual mode: control signals straight from switches ----
        sw = {5'b0, 1'b0, 3'b000, 7'b0110011}; #10; chk(led_data, 16'h0281, "manual ADD");
        sw = {5'b0, 1'b1, 3'b000, 7'b0110011}; #10; chk(led_data, 16'h0681, "manual SUB");
        sw = {5'b0, 1'b0, 3'b010, 7'b0000011}; #10; chk(led_data, 16'h0217, "manual LW");
        sw = {5'b0, 1'b0, 3'b010, 7'b0100011}; #10; chk(led_data, 16'h020A, "manual SW");
        sw = {5'b0, 1'b0, 3'b000, 7'b1100011}; #10; chk(led_data, 16'h0760, "manual BEQ");

        // ---- execute mode: run the program (switches = 0xA5A5, view 01) ----
        sw = 16'hA5A5; #10;
        for (i = 0; i < 17; i = i + 1) do_step;          // instructions 0..16

        chk(dut.rf.regs[1],  10,  "x1 ADDI");
        chk(dut.rf.regs[2],  3,   "x2 ADDI");
        chk(dut.rf.regs[3],  13,  "x3 ADD");
        chk(dut.rf.regs[4],  7,   "x4 SUB");
        chk(dut.rf.regs[5],  80,  "x5 SLL");
        chk(dut.rf.regs[6],  1,   "x6 SRL");
        chk(dut.rf.regs[7],  2,   "x7 AND");
        chk(dut.rf.regs[8],  11,  "x8 OR");
        chk(dut.rf.regs[9],  9,   "x9 XOR");
        chk(dut.memsys.dmem.memory[0], 13,   "mem[0] SW");
        chk(dut.memsys.dmem.memory[1], 7,    "mem[1] SH");
        chk(dut.memsys.dmem.memory[2], 80,   "mem[2] SB");
        chk(dut.rf.regs[10], 13,  "x10 LW");
        chk(dut.rf.regs[11], 7,   "x11 LH");
        chk(dut.rf.regs[12], 80,  "x12 LB");
        chk(dut.rf.regs[13], 32'h0000A5A5, "x13 LW from switches");
        sw = 16'hC000; #10;  chk(led_data, 16'h000D, "LED register (SW to 0x100)");   // view 10
        sw = 16'h8000; #10;
        chk(dut.idx, 17, "idx before BEQ taken");
        chk(dut.BranchTaken, 1, "BEQ x1,x1 taken");
        do_step;
        chk(dut.BranchTaken, 0, "BEQ x1,x2 not taken");
        do_step;
        chk(dut.idx, 0, "idx wraps to 0");

        if (errors == 0) $display("DATAPATH: ALL TESTS PASSED"); else $display("%0d FAILED", errors);
        $finish;
    end
endmodule

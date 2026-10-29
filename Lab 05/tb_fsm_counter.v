`timescale 1ns/1ps

module tb_fsm_counter;

    reg         clk = 0;
    reg         rst;
    reg  [15:0] sw;
    wire [15:0] led;

    // Small CLK_FREQ so each decrement tick only takes a few clock cycles in sim
    fsm_counter #(.CLK_FREQ(5)) dut (
        .clk(clk),
        .rst(rst),
        .sw (sw),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_fsm_counter.vcd");
        $dumpvars(0, tb_fsm_counter);

        rst = 1; sw = 16'd0;
        repeat (3) @(posedge clk);
        rst = 0;

        // Idle: switches = 0, LEDs should stay 0
        repeat (3) @(posedge clk);
        if (led !== 16'd0)
            $display("FAIL: LED not 0 in idle, led=%0d", led);
        else
            $display("PASS: idle state holds LEDs at 0");

        // Apply non-zero switch value -> capture and start countdown
        sw = 16'd3;
        @(posedge clk);
        sw = 16'd0;
        repeat (25) @(posedge clk);   // enough ticks to finish 3 -> 0
        if (led !== 16'd0)
            $display("FAIL: did not return to idle after countdown, led=%0d", led);
        else
            $display("PASS: countdown finished and returned to idle");

        // Reset mid-countdown
        sw = 16'd5;
        @(posedge clk);
        sw = 16'd0;
        repeat (7) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        if (led !== 16'd0)
            $display("FAIL: reset did not clear counter/LEDs, led=%0d", led);
        else
            $display("PASS: reset immediately clears counter/LEDs");

        #20 $finish;
    end

endmodule

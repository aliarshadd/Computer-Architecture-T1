`timescale 1ns / 1ps
// Lab 9 Task 3 top level (Basys-3).
// Reused unchanged from Lab 5: debouncer, leds (switch reader), switches (LED writer).
// btnC = reset, btnU = execute next instruction (sw[15]=1). See control_datapath.v for switch/LED map.
//
// The single-cycle datapath needs ~12 ns, so the core (control_datapath + LED writer) runs on a
// 50 MHz clock (core_clk = clk/2, through a BUFG). The button signals are synchronised into core_clk.
module top_control_fpga #(
    parameter LOCK_CYCLES = 20'hFFFFF        // ~21 ms at 50 MHz: ignores switch bounce on btnU
)(
    input         clk,
    input         btnC, btnU,
    input  [15:0] sw,
    output [15:0] led
);
    wire rst_raw, step_raw;
    wire [31:0] swData, unused_rd;
    wire [15:0] led_data;

    // ---- Lab 5 modules (100 MHz domain) ----
    debouncer db_rst  (.clk(clk), .pbin(btnC), .pbout(rst_raw));
    debouncer db_step (.clk(clk), .pbin(btnU), .pbout(step_raw));

    leds sw_input (
        .clk(clk), .rst(rst_raw), .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0),
        .readEnable(1'b1), .memAddress(30'd0),
        .switches(sw), .readData(swData)
    );

    // ---- core clock = clk / 2 ----
    reg core_div = 1'b0;
    always @(posedge clk) core_div <= ~core_div;
    wire core_clk;
    BUFG bufg_core (.I(core_div), .O(core_clk));

    // ---- synchronise buttons into core_clk, make one-clock step pulse ----
    reg [1:0] rst_s  = 2'b11;       // also gives a reset at power-up
    reg [1:0] step_s = 2'b00;
    reg       step_d = 1'b0;
    always @(posedge core_clk) begin
        rst_s  <= {rst_s[0],  rst_raw};
        step_s <= {step_s[0], step_raw};
        step_d <= step_s[1];
    end
    wire rst  = rst_s[1];

    // Lab 5 debouncer is a plain wire, so bounce is filtered here: after one step, ignore btnU for ~21 ms
    reg [19:0] lock = 20'd0;
    wire step_edge = step_s[1] & ~step_d;
    wire step = step_edge & (lock == 20'd0);
    always @(posedge core_clk) begin
        if (rst)             lock <= 20'd0;
        else if (step)       lock <= LOCK_CYCLES;
        else if (lock != 0)  lock <= lock - 20'd1;
    end

    // ---- datapath + control (Labs 6, 7, 8, 9) ----
    control_datapath core (
        .clk(core_clk), .rst(rst), .step(step),
        .sw(swData[15:0]), .led_data(led_data)
    );

    // ---- LED output through the Lab 5 LED writer ----
    switches led_output (
        .clk(core_clk), .rst(rst),
        .writeData({16'd0, led_data}),
        .writeEnable(1'b1), .readEnable(1'b0),
        .memAddress(30'd0), .readData(unused_rd), .leds(led)
    );
endmodule

`timescale 1ns / 1ps
// Task 3: top-level for Basys-3
//   sw[3:0]  : ALUControl (manual mode)
//   sw[15]   : auto mode (FSM steps through the operations with btnU)
//   btnC     : next display view (result low / result high / flags)
//   btnU     : next operation (auto mode)
//   btnR     : reset
//   led[15:0]: selected view of ALUResult / Zero
module fpga_top #(parameter DB_CYCLES = 2_000_000) (
    input         clk,
    input  [15:0] sw,
    input         btnC, btnU, btnR,
    output [15:0] led
);
    // Two fixed operands (as given in the lab)
    localparam [31:0] OP_A = 32'h10101010;
    localparam [31:0] OP_B = 32'h01010101;

    wire rst = btnR;
    wire [15:0] sw_s;
    wire pulse_view, pulse_op;
    wire [3:0]  alu_ctrl;
    wire [31:0] alu_result;
    wire        zero;
    wire [15:0] led_data;

    switch_if u_sw (.clk(clk), .sw_in(sw), .sw_out(sw_s));

    debounce #(.N(DB_CYCLES)) u_db_view (.clk(clk), .rst(rst), .btn_in(btnC), .pulse(pulse_view));
    debounce #(.N(DB_CYCLES)) u_db_op   (.clk(clk), .rst(rst), .btn_in(btnU), .pulse(pulse_op));

    alu_fsm u_fsm (
        .clk(clk), .rst(rst),
        .step_view(pulse_view), .step_op(pulse_op),
        .auto_mode(sw_s[15]), .sw_ctrl(sw_s[3:0]),
        .alu_result(alu_result), .zero(zero),
        .alu_ctrl(alu_ctrl), .led_data(led_data)
    );

    ALU u_alu (.A(OP_A), .B(OP_B), .ALUControl(alu_ctrl),
               .ALUResult(alu_result), .Zero(zero));

    led_if u_led (.clk(clk), .led_in(led_data), .led_out(led));
endmodule

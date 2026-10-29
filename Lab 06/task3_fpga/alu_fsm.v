`timescale 1ns / 1ps
// FSM that
//  (1) cycles the LED display view:  LOW half -> HIGH half -> FLAGS -> LOW ...
//  (2) in auto mode, steps ALUControl through all 8 operations
// ALUControl: 0000 AND | 0001 OR | 0010 ADD | 0110 SUB
//             0011 XOR | 0100 SLL | 0101 SRL | 0111 BEQ
module alu_fsm (
    input         clk,
    input         rst,
    input         step_view,        // pulse: next display view
    input         step_op,          // pulse: next operation (auto mode)
    input         auto_mode,        // 0: ALUControl from switches, 1: from FSM
    input  [3:0]  sw_ctrl,          // ALUControl from switches
    input  [31:0] alu_result,
    input         zero,
    output [3:0]  alu_ctrl,
    output reg [15:0] led_data
);
    localparam V_LOW = 2'd0, V_HIGH = 2'd1, V_FLAG = 2'd2;

    reg [1:0] view   = V_LOW;
    reg [2:0] op_idx = 3'd0;
    reg [3:0] op_code;

    always @(posedge clk) begin
        if (rst) begin
            view   <= V_LOW;
            op_idx <= 3'd0;
        end else begin
            if (step_view) view   <= (view == V_FLAG) ? V_LOW : view + 2'd1;
            if (step_op)   op_idx <= op_idx + 3'd1;      // wraps 7 -> 0
        end
    end

    always @(*) begin
        case (op_idx)
            3'd0:    op_code = 4'b0000;   // AND
            3'd1:    op_code = 4'b0001;   // OR
            3'd2:    op_code = 4'b0010;   // ADD
            3'd3:    op_code = 4'b0110;   // SUB
            3'd4:    op_code = 4'b0011;   // XOR
            3'd5:    op_code = 4'b0100;   // SLL
            3'd6:    op_code = 4'b0101;   // SRL
            default: op_code = 4'b0111;   // BEQ
        endcase
    end

    assign alu_ctrl = auto_mode ? op_code : sw_ctrl;

    always @(*) begin
        case (view)
            V_LOW:   led_data = alu_result[15:0];
            V_HIGH:  led_data = alu_result[31:16];
            default: led_data = {alu_ctrl, 11'b0, zero};  // LED15-12 = op, LED0 = Zero
        endcase
    end
endmodule

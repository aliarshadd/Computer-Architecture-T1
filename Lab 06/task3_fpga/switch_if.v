`timescale 1ns / 1ps
// Switch interface: 2-flop synchronizer for the slide switches
module switch_if (
    input         clk,
    input  [15:0] sw_in,
    output [15:0] sw_out
);
    reg [15:0] s1 = 16'b0, s2 = 16'b0;
    always @(posedge clk) begin
        s1 <= sw_in;
        s2 <= s1;
    end
    assign sw_out = s2;
endmodule

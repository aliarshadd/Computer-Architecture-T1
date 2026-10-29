`timescale 1ns / 1ps
// LED interface: registered output to the LEDs
module led_if (
    input         clk,
    input  [15:0] led_in,
    output reg [15:0] led_out
);
    initial led_out = 16'b0;
    always @(posedge clk) led_out <= led_in;
endmodule

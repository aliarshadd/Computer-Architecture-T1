`timescale 1ns / 1ps
// Button debouncer: output "pulse" is high for one clock per clean press.
// N = number of stable clock cycles required (100 MHz, N = 2_000_000 -> 20 ms)
module debounce #(parameter N = 2_000_000) (
    input  clk,
    input  rst,
    input  btn_in,
    output pulse
);
    reg s1 = 1'b0, s2 = 1'b0;           // synchronizer
    reg state = 1'b0, state_d = 1'b0;   // debounced level and its delayed copy
    reg [31:0] cnt = 32'd0;

    always @(posedge clk) begin
        s1 <= btn_in;
        s2 <= s1;
        if (rst) begin
            cnt <= 0; state <= 1'b0; state_d <= 1'b0;
        end else begin
            state_d <= state;
            if (s2 == state)
                cnt <= 0;
            else begin
                cnt <= cnt + 1;
                if (cnt == N - 1) begin
                    state <= s2;
                    cnt   <= 0;
                end
            end
        end
    end
    assign pulse = state & ~state_d;     // rising edge of the clean button
endmodule

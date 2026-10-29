module top (
    input  wire        clk,     // 100 MHz onboard oscillator
    input  wire        btnC,    // center button, raw (used as reset)
    input  wire [15:0] sw,
    output wire [15:0] led
);

    wire rst_debounced;

    debouncer btn_debounce (
        .clk  (clk),
        .pbin (btnC),
        .pbout(rst_debounced)
    );

    fsm_counter #(.CLK_FREQ(100_000_000)) u_fsm_counter (
        .clk (clk),
        .rst (rst_debounced),
        .sw  (sw),
        .led (led)
    );

endmodule

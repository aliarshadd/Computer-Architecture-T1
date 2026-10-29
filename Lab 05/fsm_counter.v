module fsm_counter #(
    parameter CLK_FREQ = 100_000_000   // clock cycles per decrement tick (~1s @100MHz)
)(
    input  wire        clk,
    input  wire        rst,           // synchronous, active-high, debounced
    input  wire [15:0] sw,
    output reg  [15:0] led
);

    // FSM states
    localparam S_IDLE  = 1'b0;
    localparam S_COUNT = 1'b1;

    reg        state;
    reg [15:0] count;

    // Tick generator: one decrement pulse every CLK_FREQ clock cycles
    reg  [31:0] tick_cnt;
    wire        tick = (tick_cnt == CLK_FREQ - 1);

    always @(posedge clk) begin
        if (rst)
            tick_cnt <= 32'd0;
        else if (state == S_COUNT)
            tick_cnt <= tick ? 32'd0 : tick_cnt + 32'd1;
        else
            tick_cnt <= 32'd0;
    end

    // State + counter logic
    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            count <= 16'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (sw != 16'd0) begin
                        count <= sw;      // capture switch value
                        state <= S_COUNT;
                    end
                end
                S_COUNT: begin
                    if (tick) begin
                        if (count == 16'd0)
                            state <= S_IDLE;   // countdown finished
                        else
                            count <= count - 16'd1;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            S_IDLE:  led = 16'd0;
            S_COUNT: led = count;
            default: led = 16'd0;
        endcase
    end

endmodule

// Reference implementation — replace with the debouncer provided in your
// course materials if its internals differ; port names/signature match.
module debouncer #(
    parameter DEBOUNCE_COUNT = 500_000   // ~5ms @ 100MHz
)(
    input  wire clk,
    input  wire pbin,
    output reg  pbout
);

    reg [19:0] counter;
    reg        pbin_sync0, pbin_sync1;

    always @(posedge clk) begin
        pbin_sync0 <= pbin;
        pbin_sync1 <= pbin_sync0;
    end

    always @(posedge clk) begin
        if (pbin_sync1 == pbout) begin
            counter <= 20'd0;
        end else begin
            counter <= counter + 20'd1;
            if (counter >= DEBOUNCE_COUNT)
                pbout <= pbin_sync1;
        end
    end

endmodule

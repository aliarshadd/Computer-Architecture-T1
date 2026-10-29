 
`timescale 1ns / 1ps 
module top_rf_alu( 
    input clk, btnC, 
    input [15:0] sw, 
    output [15:0] led 
); 
wire rst, slowclk, Zero; 
wire [31:0] swData, ReadData1, ReadData2, ALUResult; 
reg [4:0] rs1, rs2, rd; 
reg [31:0] WriteData; 
reg [3:0] ALUControl, state; 
reg WriteEnable; 
reg [23:0] count; 
debouncer db(.clk(clk), .pbin(btnC), .pbout(rst)); 
clock_divider cd( 
    .clk_in(clk), .rst(rst), .clk_out(slowclk) 
); 
leds sw_input( 
    .clk(clk), .rst(rst), .btns(16'd0), 
    .writeData(32'd0), .writeEnable(1'b0), 
    .readEnable(1'b1), .memAddress(30'd0), 
    .switches(sw), .readData(swData) 
); 
switches led_output( 
    .clk(clk), .rst(rst), 
    .writeData({16'd0, state, Zero, ALUResult[10:0]}), 
    .writeEnable(1'b1), .readEnable(1'b0), 
    .memAddress(30'd0), .readData(), .leds(led) 
); 
RegisterFile rf( 
    .clk(clk), .rst(rst), .WriteEnable(WriteEnable), 
    .rs1(rs1), .rs2(rs2), .rd(rd), 
    .WriteData(WriteData), 
    .ReadData1(ReadData1), .ReadData2(ReadData2) 
); 
ALU alu( 
    .A(ReadData1), .B(ReadData2), 
    .ALUControl(ALUControl), 
    .ALUResult(ALUResult), .Zero(Zero) 
); 
always @(posedge slowclk or posedge rst) begin 
    if (rst) begin
 state <= 0; 
        count <= 0; 
    end 
    else if (count == 24'd16666666) begin 
        count <= 0; 
        if (state < 12) 
            state <= state + 1; 
    end 
    else 
        count <= count + 1; 
end 
always @(*) begin 
    WriteEnable = 0; 
    rs1 = 1; rs2 = 2; rd = 0; 
    WriteData = 0; ALUControl = 0; 
    case (state) 
        0: begin 
            WriteEnable = 1; rd = 1; 
            WriteData = 32'h10101010; 
        end 
        1: begin 
            WriteEnable = 1; rd = 2; 
            WriteData = 32'h01010101; 
        end 
        2: begin 
            WriteEnable = 1; rd = 3; 
            WriteData = 32'd5; 
        end 
        3,4,5,6,7,8,9: begin 
            case (state) 
                3: ALUControl = 2; 
                4: ALUControl = 6; 
                5: ALUControl = 0; 
                6: ALUControl = 1; 
                7: ALUControl = 3; 
                8: ALUControl = 4; 
                9: ALUControl = 5; 
            endcase 
            WriteEnable = 1; 
            rd = state + 1; 
            WriteData = ALUResult; 
        end 
        10: begin 
            rs1 = 3; rs2 = 3; 
            ALUControl = 7; 
            WriteEnable = 1; rd = 11; 
            WriteData = {31'd0, Zero}; 
        end
	11: rs1 = 11; 
	12: begin 
		ALUControl = swData[3:0]; 
		WriteEnable = swData[4]; 
		rd = swData[9:5]; 
		rs1 = swData[14:10]; 
		rs2 = swData[15] ? 1 : 2; 
		WriteData = ALUResult; 
	end 
    endcase 
end 
endmodule 
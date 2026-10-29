`timescale 1ns / 1ps 
module RF_ALU_FSM_tb; 
reg clk, rst, WriteEnable; 
reg [4:0] rs1, rs2, rd; 
reg [31:0] WriteData; 
reg [3:0] ALUControl; 
reg [3:0] state; 
wire [31:0] ReadData1, ReadData2; 
wire [31:0] ALUResult; 
wire Zero; 
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
localparam WRITE1=0, WRITE2=1, WRITE3=2, 
           ADD=3, SUB=4, AND_OP=5, OR_OP=6, 
           XOR_OP=7, SLL=8, SRL=9, 
           BEQ=10, READ_FLAG=11, DONE=12; 
initial clk = 0; 
always #5 clk = ~clk; 
initial begin 
    rst = 1; 
    #10 rst = 0; 
    #140 $finish; 
end 
always @(posedge clk) begin 
    if (rst) 
        state <= WRITE1; 
    else if (state < DONE) 
        state <= state + 1; 
end 
always @(*) begin 
    WriteEnable = 0; 
    rs1 = 1; 
    rs2 = 2; 
    rd = 0; 
    WriteData = 0; 
    ALUControl = 0; 
    case(state) 
        WRITE1: begin 
  WriteEnable = 1; 
            rd = 1; 
            WriteData = 32'h10101010; 
        end 
        WRITE2: begin 
            WriteEnable = 1; 
            rd = 2; 
            WriteData = 32'h01010101; 
        end 
        WRITE3: begin 
            WriteEnable = 1; 
            rd = 3; 
            WriteData = 32'h00000005; 
        end 
        ADD: begin 
            ALUControl = 4'b0010; 
            WriteEnable = 1; 
            rd = 4; 
            WriteData = ALUResult; 
        end 
        SUB: begin 
            ALUControl = 4'b0110; 
            WriteEnable = 1; 
            rd = 5; 
            WriteData = ALUResult; 
        end 
        AND_OP: begin 
            ALUControl = 4'b0000; 
            WriteEnable = 1; 
            rd = 6; 
            WriteData = ALUResult; 
        end 
        OR_OP: begin 
            ALUControl = 4'b0001; 
            WriteEnable = 1; 
            rd = 7; 
            WriteData = ALUResult; 
        end 
        XOR_OP: begin 
            ALUControl = 4'b0011; 
            WriteEnable = 1; 
            rd = 8; 
            WriteData = ALUResult; 
        end 
        SLL: begin 
            ALUControl = 4'b0100; 
            WriteEnable = 1; 
            rd = 9; 
	WriteData = ALUResult; 
        end 
        SRL: begin 
            ALUControl = 4'b0101; 
            WriteEnable = 1; 
            rd = 10; 
            WriteData = ALUResult; 
        end 
        BEQ: begin 
            rs1 = 3; 
            rs2 = 3; 
            ALUControl = 4'b0111; 
            WriteEnable = 1; 
            rd = 11; 
            WriteData = {31'd0, Zero}; 
        end 
        READ_FLAG: begin 
            rs1 = 11; 
        end 
    endcase 
end 
endmodule	
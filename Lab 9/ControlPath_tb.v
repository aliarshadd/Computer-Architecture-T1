`timescale 1ns / 1ps
module ControlPath_tb;
    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire       RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    integer errors = 0;

    MainControl mc (.opcode(opcode), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemRead(MemRead),
    .MemWrite(MemWrite), .MemtoReg(MemtoReg), .Branch(Branch), .ALUOp(ALUOp));
    ALUControl  ac (.ALUOp(ALUOp), .funct3(funct3), .funct7(funct7), .ALUControl(ALUControl));
    // expected = {RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,Branch,ALUOp[1:0],ALUControl[3:0]}
    task check;
        input [6:0]  op;
        input [2:0]  f3;
        input [6:0]  f7;
        input [11:0] exp;
        input [63:0] name;
        begin
            opcode = op; funct3 = f3; funct7 = f7; #10;
            if ({RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,Branch,ALUOp,ALUControl} !== exp) begin
                errors = errors + 1;
                $display("FAIL %0s: got %b exp %b", name,
                    {RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,Branch,ALUOp,ALUControl}, exp);
            end else
                $display("PASS %0s: RegW=%b ALUSrc=%b MemR=%b MemW=%b M2R=%b Br=%b ALUOp=%b ALUCtl=%b",
                         name, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp, ALUControl);
        end
    endtask

    initial begin
        $dumpfile("ControlPath_tb.vcd"); $dumpvars(0, ControlPath_tb);
        //     opcode      f3     funct7       RW AS MR MW M2R Br  ALUOp ALUCtl
        check(7'b0110011, 3'b000, 7'b0000000, {6'b100000, 2'b10, 4'b0010}, "ADD");
        check(7'b0110011, 3'b000, 7'b0100000, {6'b100000, 2'b10, 4'b0110}, "SUB");
        check(7'b0110011, 3'b001, 7'b0000000, {6'b100000, 2'b10, 4'b0100}, "SLL");
        check(7'b0110011, 3'b101, 7'b0000000, {6'b100000, 2'b10, 4'b0101}, "SRL");
        check(7'b0110011, 3'b111, 7'b0000000, {6'b100000, 2'b10, 4'b0000}, "AND");
        check(7'b0110011, 3'b110, 7'b0000000, {6'b100000, 2'b10, 4'b0001}, "OR");
        check(7'b0110011, 3'b100, 7'b0000000, {6'b100000, 2'b10, 4'b0011}, "XOR");
        check(7'b0010011, 3'b000, 7'b0000000, {6'b110000, 2'b00, 4'b0010}, "ADDI");
        check(7'b0000011, 3'b010, 7'b0000000, {6'b111010, 2'b00, 4'b0010}, "LW");
        check(7'b0000011, 3'b001, 7'b0000000, {6'b111010, 2'b00, 4'b0010}, "LH");
        check(7'b0000011, 3'b000, 7'b0000000, {6'b111010, 2'b00, 4'b0010}, "LB");
        check(7'b0100011, 3'b010, 7'b0000000, {6'b010100, 2'b00, 4'b0010}, "SW");
        check(7'b0100011, 3'b001, 7'b0000000, {6'b010100, 2'b00, 4'b0010}, "SH");
        check(7'b0100011, 3'b000, 7'b0000000, {6'b010100, 2'b00, 4'b0010}, "SB");
        check(7'b1100011, 3'b000, 7'b0000000, {6'b000001, 2'b01, 4'b0111}, "BEQ");
        // undefined opcode -> everything off
        check(7'b1111111, 3'b000, 7'b0000000, {6'b000000, 2'b00, 4'b0010}, "ILLEGAL");

        if (errors == 0) $display("CONTROL PATH: ALL TESTS PASSED"); else $display("%0d FAILED", errors);
        $finish;
    end
endmodule

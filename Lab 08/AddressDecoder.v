AddressDecoder: (Decodes upper address bits): 
 
module AddressDecoder ( 
    input [9:8] address, 
    input readEnable, 
    input writeEnable, 
    output reg DataMemWrite, 
    output reg DataMemRead, 
    output reg LEDWrite, 
    output reg SwitchReadEnable 
); 
 
    always @(*) begin 
        DataMemWrite = 0; 
        DataMemRead = 0; 
        LEDWrite = 0; 
        SwitchReadEnable = 0; 
 
        case (address) 
            2'b00: begin 
                DataMemWrite = writeEnable; 
                DataMemRead = readEnable; 
            end 
            2'b01: begin 
                LEDWrite = writeEnable; 
            end 
            2'b10: begin 
                SwitchReadEnable = readEnable; 
            end 
            default: begin 
            end 
        endcase 
    end 
endmodule
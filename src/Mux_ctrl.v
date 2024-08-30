module Mux_ctrl(
    input wire       hazard_i,      // <- HazardDetect
    input wire [4:0] RDaddr_i,      // <- IF_ID
    input wire [1:0] ALUop_i,       // <- Control
    input wire       ALUsrc_i,      // <- Control
    input wire       RegWrite_i,    // <- Control
    input wire       MemRead_i,     // <- Control
    input wire       MemWrite_i,    // <- Control
    input wire       MemToReg_i,    // <- Control    
    output reg [4:0] RDaddr_o,      // -> ID_EX
    output reg [1:0] ALUop_o,       // -> ID_EX
    output reg       ALUsrc_o,      // -> ID_EX
    output reg       RegWrite_o,    // -> ID_EX
    output reg       MemRead_o,     // -> ID_EX
    output reg       MemWrite_o,    // -> ID_EX
    output reg       MemToReg_o     // -> ID_EX
    );

    always @(*)
    begin
        case(hazard_i)

        1'b0:
        begin
        RDaddr_o    <= RDaddr_i;  
        ALUop_o     <= ALUop_i;
        ALUsrc_o    <= ALUsrc_i; 
        RegWrite_o  <= RegWrite_i;
        MemRead_o   <= MemRead_i;
        MemWrite_o  <= MemWrite_i;
        MemToReg_o  <= MemToReg_i;
        end

        1'b1: 
        begin
        RDaddr_o    <= 4'b0;  
        ALUop_o     <= 2'b0;
        ALUsrc_o    <= 1'b0; 
        RegWrite_o  <= 1'b0;
        MemRead_o   <= 1'b0;
        MemWrite_o  <= 1'b0;
        MemToReg_o  <= 1'b0;
        end    

        endcase
    end

endmodule
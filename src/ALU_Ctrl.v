module ALU_Ctrl(
    input wire [9:0] funct_i,   // <- ID_EX {funct7, funct3}
    input wire [1:0] ALUop_i,   // <- ID_EX
    output reg [2:0] ALUctrl_o  // -> ALU
    );

    always @(*)
    begin
        case(ALUop_i)
            2'b00 : ALUctrl_o = 3'b000; // NOP
            2'b01 : ALUctrl_o = 3'b001; // Load, Store
            // I-type
            2'b10 :
            begin
                case(funct_i[2:0])
                    3'b000 : ALUctrl_o = 3'b001; // ADDI
                    3'b100 : ALUctrl_o = 3'b010; // SUBI
                    3'b110 : ALUctrl_o = 3'b100; // ORI
                    3'b111 : ALUctrl_o = 3'b101; // ANDI
                    default : ALUctrl_o = 3'b000;   // NOP
                endcase
            end
            // R-type
            2'b11 :
            begin
                case(funct_i)
                    10'b000_0000_000 : ALUctrl_o = 3'b001;    // ADD
                    10'b010_0000_000 : ALUctrl_o = 3'b010;    // SUB
                    10'b000_0000_100 : ALUctrl_o = 3'b011;    // XOR
                    10'b000_0000_110 : ALUctrl_o = 3'b100;    // OR
                    10'b000_0000_111 : ALUctrl_o = 3'b101;    // AND
                    default : ALUctrl_o = 3'b000;       // NOP
                endcase
            end
        endcase
    end

endmodule

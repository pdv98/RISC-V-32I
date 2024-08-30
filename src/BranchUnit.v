module BranchUnit (
    input wire [31:0] RSdata_i, // <- Registers
    input wire [31:0] RTdata_i, // <- Registers
    input wire [ 6:0] opcode,     // <- IF_ID
    input wire [ 2:0] funct3,   // <- IF_ID
    output wire       branch,   // -> Mux_pc
    output wire       flush     // -> IF_ID
    );

    wire reg_equal;         // BEQ
    wire reg_not_equal;     // BNE
    wire less_than;         // BLT
    wire greater_or_equal;  // BGE

    assign branch = (opcode == 7'b1100011);
    
    assign reg_equal = (RSdata_i == RTdata_i);
    assign reg_not_equal = (RSdata_i != RTdata_i);
    assign less_than = ($signed(RSdata_i) < $signed(RTdata_i));
    assign greater_or_equal = ($signed(RSdata_i) >= $signed(RTdata_i));
    
    assign flush = branch ?  // opcode 7'b1100011 = branch
        (funct3 == 3'b000 ? reg_equal :
         funct3 == 3'b001 ? reg_not_equal :
         funct3 == 3'b100 ? less_than :
         funct3 == 3'b101 ? greater_or_equal : 1'b0) : 1'b0;

endmodule

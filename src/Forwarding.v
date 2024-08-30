module Forwarding(   
    input wire          MEM_RegWrite_i,     // <- EX_MEM
    input wire [4:0]    MEM_RDaddr_i,       // <- EX_MEM
    input wire [4:0]    EX_RSaddr_i,        // <- ID_EX
    input wire [4:0]    EX_RTaddr_i,        // <- ID_EX
    input wire          WB_RegWrite_i,      // <- MEM_WB
    input wire [4:0]    WB_RDaddr_i,        // <- MEM_WB
    output reg [1:0]    forward_0,          // -> Mux_fwd0
    output reg [1:0]    forward_1           // -> Mux_fwd1
    );

    always @(*)
    begin
        forward_0 = 2'b01;
        if(MEM_RegWrite_i && (MEM_RDaddr_i != 5'b0) && (MEM_RDaddr_i == EX_RSaddr_i))
            forward_0 = 2'b10;
        else if(WB_RegWrite_i && (WB_RDaddr_i != 5'b0) && (WB_RDaddr_i == EX_RSaddr_i))
            forward_0 = 2'b11;

        forward_1 = 2'b01;
        if(MEM_RegWrite_i && (MEM_RDaddr_i != 5'b0) && (MEM_RDaddr_i == EX_RTaddr_i))
            forward_1 = 2'b10;
        else if(WB_RegWrite_i && (WB_RDaddr_i != 5'b0) && (WB_RDaddr_i == EX_RTaddr_i))
            forward_1 = 2'b11;
    end

endmodule

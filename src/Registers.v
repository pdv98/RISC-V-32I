module Registers (
    input  wire        CLK,              // <- external
    input  wire        nRESET,           // <- external
    input  wire [ 4:0] RSaddr_i,         // <- IF_ID
    input  wire [ 4:0] RTaddr_i,         // <- IF_ID
    input  wire [ 4:0] RDaddr_i,         // <- EX_MEM
    input  wire [31:0] RDdata_i,         // <- Mux_DM
    input  wire        RegWrite_i,       // <- EX_MEM
    output wire [31:0] RSdata_o,         // -> ID_EX
    output wire [31:0] RTdata_o,         // -> ID_EX
    output wire [31:0] x1_o,             // Debug output for x1
    output wire [31:0] x2_o,             // Debug output for x2
    output wire [31:0] x3_o,             // Debug output for x3
    output wire [31:0] x4_o,             // Debug output for x4
    output wire [31:0] x5_o              // Debug output for x5
    );

    integer i;

    // register file
    reg [31:0] register [0:31];     // array of 32 32-bit registers

    // read
    assign RSdata_o = register[RSaddr_i];
    assign RTdata_o = register[RTaddr_i];

    // debug outputs for registers x1 to x5
    assign x1_o = register[1];      // Output for register x1
    assign x2_o = register[2];      // Output for register x2
    assign x3_o = register[3];      // Output for register x3
    assign x4_o = register[4];      // Output for register x4
    assign x5_o = register[5];      // Output for register x5

    // write
    always @(posedge CLK or negedge nRESET)
    begin
        if (~nRESET)    // erase registers
        begin
            for(i=0; i<32; i=i+1)
                register[i] <= 32'b0;
        end
        else    // write data to the destination register
        begin
            if (RegWrite_i)
                register[RDaddr_i] <= RDdata_i;
        end      
    end

endmodule
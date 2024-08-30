module INSTR_MEM(
    input  wire         CLK,       // Clock signal
    input  wire         nRESET,    // Asynchronous reset
    input  wire [31:0]  addr_i,    // Input address (PC)
    output reg  [31:0]  instr_o    // 32-bit output instruction
    );

    reg [31:0] memory [0:63];   // 32 x 64 memory (32-bit wide)

    // Initialize memory with contents from an external file
    initial
    begin
        $readmemh("instructions.hex", memory);
    end

    // Re-load memory on reset with synchronization to clock
    always @(posedge CLK or negedge nRESET)
    begin
        if (~nRESET)    // Re-load memory on reset
        begin
            $readmemh("instructions.hex", memory);
        end
    end

    // Output instruction based on pc address
    always @(*) begin
        instr_o = memory[addr_i >> 2];
    end

endmodule


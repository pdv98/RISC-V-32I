module PC(
    input wire        CLK,          // <- external
    input wire        nRESET,       // <- external
    input wire        hazard_i,     // <- HazardDetect
    input wire [31:0] pc_i,         // <- Mux_pc
    output reg [31:0] pc_o          // -> Instr_Mem, Add_pc
    );

    always @(posedge CLK, negedge nRESET)
    begin
        if (~nRESET) 
            pc_o <= 32'b0;  // reset
        else
        begin
            if (hazard_i) 
                pc_o <= pc_o; // stall
            else          
                pc_o <= pc_i; // default
        end
    end

endmodule

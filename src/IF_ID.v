module IF_ID(
    input wire         CLK,          // <- external
    input wire         nRESET,       // <- external
    input wire [31:0]  pc_i,         // <- Add_pc
    input wire [31:0]  instr_i,      // <- INSTR_MEM
    input wire         hazard_i,     // <- HazardDetect
    input wire         flush_i,      // <- BranchUnit
    input wire [11:0]  pc_offset_i,  // <- INSTR_MEM (assign)
    output reg [11:0]  pc_offset_o,  // -> Imm_Extend_B
    output reg [31:0]  pc_o,         // -> ADD_br
    output reg [31:0]  instr_o       // -> ID_EX, Control, ...
	);

    always @(posedge CLK) 
	begin
        if(~nRESET)
		begin
            pc_o        <= 32'b0;
            instr_o     <= 32'b0;
            pc_offset_o <= 12'b0;
        end
        else if(flush_i)		// Pipeline Flush
		begin
            pc_o        <= pc_i;	// update
            instr_o     <= 32'b0;	// zero
            pc_offset_o <= 12'b0;	// zero
        end
        else if(hazard_i)		// Data Hazard
		begin
            pc_o        <= pc_i;	    // update
            instr_o     <= instr_o;	    // keep
            pc_offset_o <= pc_offset_i;	// update
        end
        else					// Default
		begin
            pc_o        <= pc_i;	    // update
            instr_o     <= instr_i;	    // update
            pc_offset_o <= pc_offset_i;	// update
        end
    end

endmodule

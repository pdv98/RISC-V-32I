module EX_MEM(
	input wire 			CLK,			// <- external
	input wire 			nRESET,			// <- external
	input wire [31:0] 	pc_i,			// <- ID_EX
	input wire [31:0] 	instr_i,		// <- ID_EX
	input wire [31:0] 	ALUresult_i,	// <- ALU
	input wire [31:0] 	RDdata_i,		// <- Mux_fwd1
	input wire [ 4:0] 	RDaddr_i,		// <- ID_EX
	input wire 			RegWrite_i,		// <- ID_EX
	input wire 			MemToReg_i,		// <- ID_EX
	input wire 			MemRead_i,		// <- ID_EX
	input wire 			MemWrite_i,		// <- ID_EX
	output reg [31:0] 	ALUresult_o,	// -> MEM_WB, DATA_MEM, Mux_fwd0, Mux_fwd1
	output reg [31:0] 	RDdata_o, 		// -> DATA_MEM
	output reg [ 4:0]	RDaddr_o,		// -> MEM_WB
	output reg 			RegWrite_o,		// -> MEM_WB
	output reg 			MemToReg_o,		// -> MEM_WB
	output reg 			MemRead_o,		// -> MEM_WB
	output reg 			MemWrite_o		// -> MEM_WB
	);

	always @(posedge CLK or negedge nRESET)
	begin
		if(~nRESET)
		begin
			ALUresult_o 	<= 32'b0;
			RDdata_o 		<= 32'b0;
			RDaddr_o		<= 5'b0;
			RegWrite_o 		<= 1'b0;
			MemToReg_o 		<= 1'b0;
			MemRead_o 		<= 1'b0;
			MemWrite_o 		<= 1'b0;
			
		end
		else
		begin
			ALUresult_o 	<= ALUresult_i;
			RDdata_o 		<= RDdata_i;
			RDaddr_o 		<= RDaddr_i;
			RegWrite_o 		<= RegWrite_i;
			MemToReg_o 		<= MemToReg_i;
			MemRead_o 		<= MemRead_i;
			MemWrite_o 		<= MemWrite_i;
		end
	end

endmodule
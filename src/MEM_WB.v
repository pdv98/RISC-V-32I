module MEM_WB(
	input wire 			CLK,			// <- external
	input wire 			nRESET,			// <- external
	input wire [31:0] 	ALUresult_i,	// <- EX_MEM
	input wire [ 4:0]	RDaddr_i,		// <- EX_MEM
	input wire 			RegWrite_i,		// <- EX_MEM
	input wire 			MemToReg_i,		// <- EX_MEM
	input wire [31:0] 	MemData_i,		// <- DATA_MEM
	
	output reg [31:0] 	ALUresult_o,	// -> Mux_WB
	output reg [ 4:0] 	RDaddr_o,		// -> Fowarding, Registers
	output reg 			RegWrite_o,		// -> Fowarding, Registers
	output reg 			MemToReg_o,		// -> Mux_WB
	output reg [31:0] 	MemData_o		// -> Mux_WB
	);

	always @(posedge CLK or negedge nRESET)
	begin
		if(~nRESET)
		begin
			ALUresult_o 	<= 32'b0;
			RDaddr_o 		<= 5'b0;
			RegWrite_o 		<= 1'b0;
			MemToReg_o 		<= 1'b0;
			MemData_o		<= 32'b0;
		end
		else
		begin
			ALUresult_o 	<= ALUresult_i;
			RDaddr_o 		<= RDaddr_i;
			RegWrite_o 		<= RegWrite_i;
			MemToReg_o 		<= MemToReg_i;
			MemData_o 		<= MemData_i;
		end
	end

endmodule

module ID_EX(
	input wire 		  CLK,				// <- external
	input wire 		  nRESET,			// <- external
	input wire [31:0] pc_i,				// <- IF_ID
	input wire [31:0] instr_i,			// <- IF_ID
	input wire [31:0] RDdata0_i,		// <- Registers
	input wire [31:0] RDdata1_i,		// <- Registers
	input wire [31:0] imm_extd_ISi,		// <- Imm_Extend_IS
	input wire [ 4:0] RSaddr_i,			// <- IF_ID
    input wire [ 4:0] RTaddr_i,			// <- IF_ID
	input wire [ 4:0] RDaddr_i,			// <- Mux_ctrl
	input wire [ 1:0] ALUop_i,			// <- Mux_ctrl
	input wire 		  ALUsrc_i,			// <- Mux_ctrl
	input wire 		  RegWrite_i,		// <- Mux_ctrl
	input wire 		  MemToReg_i,		// <- Mux_ctrl
	input wire 		  MemRead_i,		// <- Mux_ctrl
	input wire 		  MemWrite_i,		// <- Mux_ctrl
	output reg [31:0] pc_o,				// -> EX_MEM
	output reg [31:0] instr_o,			// -> EX_MEM
	output reg [31:0] RDdata0_o,		// -> Mux_fwd1
	output reg [31:0] RDdata1_o,		// -> Mux_fwd2
	output reg [31:0] imm_extd_ISo,		// -> Mux_alu
	output reg [ 4:0] RSaddr_o,			// -> Forwarding
	output reg [ 4:0] RTaddr_o,			// -> Forwarding
	output reg [ 4:0] RDaddr_o,			// -> EX_MEM
	output reg [ 1:0] ALUop_o,			// -> ALU_ctrl
	output reg  	  ALUsrc_o,			// -> Mux_alu
	output reg  	  RegWrite_o,		// -> EX_MEM
	output reg  	  MemToReg_o,		// -> EX_MEM
	output reg  	  MemRead_o,		// -> EX_MEM, Hazard
	output reg  	  MemWrite_o		// -> EX_MEM
	);

	always @(posedge CLK or negedge nRESET)
	begin
		if(~nRESET)
		begin
			pc_o 				<= 32'b0;
			instr_o 			<= 32'b0;
			RDdata0_o 			<= 32'b0;
			RDdata1_o 			<= 32'b0;
			imm_extd_ISo 		<= 32'b0;
			RDaddr_o 			<= 5'b0;
			ALUop_o 			<= 2'b0;
			ALUsrc_o 			<= 1'b0;
			RegWrite_o 			<= 1'b0;
			MemToReg_o 			<= 1'b0;
			MemRead_o 			<= 1'b0;
			MemWrite_o 			<= 1'b0;
			RSaddr_o 			<= 5'b0;
			RTaddr_o 			<= 5'b0;
		end

		else
		begin
			pc_o 				<= pc_i ;
			instr_o 			<= instr_i;
			RDdata0_o 			<= RDdata0_i;
			RDdata1_o 			<= RDdata1_i;
			imm_extd_ISo 		<= imm_extd_ISi;
			RDaddr_o 			<= RDaddr_i;
			ALUop_o 			<= ALUop_i;
			ALUsrc_o 			<= ALUsrc_i;
			RegWrite_o 			<= RegWrite_i;
			MemToReg_o 			<= MemToReg_i;
			MemRead_o 			<= MemRead_i;
			MemWrite_o 			<= MemWrite_i;
			RSaddr_o 			<= RSaddr_i;
			RTaddr_o 			<= RTaddr_i;
		end
	end

endmodule

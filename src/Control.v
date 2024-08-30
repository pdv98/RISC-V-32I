module Control(
	input wire [6:0] ID_op_i,		// <- IF_ID
	output reg [1:0] ALUop_o,		// -> Mux_ctrl
	output reg 		 ALUsrc_o,		// -> Mux_ctrl
	output reg 		 RegWrite_o,	// -> Mux_ctrl
	output reg 		 MemRead_o,		// -> Mux_ctrl
	output reg 		 MemWrite_o,	// -> Mux_ctrl
	output reg 		 MemToReg_o,	// -> Mux_ctrl
	output reg 		 imm_sel		// -> IMM_Extend_IS
	);

	always @(*)
	begin
		case(ID_op_i)	// IF_ID_instr_o[6:0]

		7'b0110011: 	// R-type (ADD, SUB, XOR, OR, AND)
		begin
		ALUop_o 	= 2'b11;
		ALUsrc_o 	= 1'b0;
		RegWrite_o 	= 1'b1;
		MemRead_o 	= 1'b0;
		MemWrite_o 	= 1'b0;
		MemToReg_o 	= 1'b0;
		imm_sel 	= 1'b0;
		end	

		7'b0010011:		// I-type ADDI, XORI, ORI, ANDI
		begin
		ALUop_o 	= 2'b10;
		ALUsrc_o 	= 1'b1;
		RegWrite_o 	= 1'b1;
		MemRead_o 	= 1'b0;
		MemWrite_o 	= 1'b0;
		MemToReg_o 	= 1'b0;
		imm_sel 	= 1'b0;
		end

		7'b0000011:		// I-type Load
		begin
		ALUop_o 	= 2'b01;
		ALUsrc_o 	= 1'b1;
		MemRead_o 	= 1'b1;
		MemToReg_o 	= 1'b1;
		RegWrite_o 	= 1'b1;
		MemWrite_o 	= 1'b0;
		imm_sel 	= 1'b0;
		end	

		7'b0100011:		// S-type Store
		begin
		ALUop_o 	= 2'b01;
		ALUsrc_o 	= 1'b1;
		MemWrite_o 	= 1'b1;
		RegWrite_o 	= 1'b0;
		MemRead_o 	= 1'b0;
		MemToReg_o 	= 1'b0;
		imm_sel 	= 1'b1;
		end
/*
		7'b1100011: 	// B-type Branch
		begin
		ALUop_o 	= 2'b01;
		ALUsrc_o 	= 1'b1;
		RegWrite_o 	= 1'b0;
		MemRead_o 	= 1'b0;
		MemWrite_o 	= 1'b0;
		MemToReg_o 	= 1'b0;
		imm_sel 	= 1'b0;
		end	
*/
		default: 
		begin
		ALUop_o 	= 2'b00;
		ALUsrc_o 	= 1'b1;
		RegWrite_o 	= 1'b0;
		MemRead_o 	= 1'b0;
		MemWrite_o 	= 1'b0;
		MemToReg_o 	= 1'b0;
		imm_sel 	= 1'b0;
		end
		endcase
	end

endmodule
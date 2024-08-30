module ALU(
	input  wire [31:0] data1_i,		// <- Mux_fwd0
	input  wire [31:0] data2_i,		// <- Mux_alu
	input  wire [ 2:0] ALUctrl_i,	// <- ALU_Ctrl
	output reg  [31:0] result		// -> EX_MEM
	);

	parameter ADD = 3'b001;
	parameter SUB = 3'b010;
	parameter XOR = 3'b011;
	parameter OR  = 3'b100;
	parameter AND = 3'b101;

	always @(*)
	begin
		case(ALUctrl_i)
			ADD : result = data1_i + data2_i;
			SUB : result = data1_i - data2_i;
			XOR : result = data1_i ^ data2_i;
			OR  : result = data1_i | data2_i;
			AND : result = data1_i & data2_i;
			default : result = data1_i;
		endcase
	end

endmodule

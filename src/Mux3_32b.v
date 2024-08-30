module Mux3_32b(
    input wire [ 1:0] sel,
    input wire [31:0] data1_i,
    input wire [31:0] data2_i,
    input wire [31:0] data3_i,
    output reg [31:0] data_o
    );

    always @(*)
    begin
    	case(sel)
            2'b00: data_o = 32'b0;
            2'b01: data_o = data1_i;
            2'b10: data_o = data2_i;
    		2'b11: data_o = data3_i;
    	endcase
    end

endmodule
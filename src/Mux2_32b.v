module Mux2_32b(
    input  wire [31:0] data1_i,
    input  wire [31:0] data2_i,
    input  wire        select_i,
    output wire [31:0] data_o
    );

    assign data_o = (select_i) ? data2_i : data1_i ;

endmodule
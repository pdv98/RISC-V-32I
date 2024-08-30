module Add2_32b(
    input  wire [31:0] data1_i,
    input  wire [31:0] data2_i,
    output wire [31:0] data_o
    );

    assign data_o = data1_i + data2_i;

endmodule
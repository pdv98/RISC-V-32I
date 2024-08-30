module HazardUnit(
    input  wire [4:0] IF_IDrs_i,
    input  wire [4:0] IF_IDrt_i,
    input  wire [4:0] ID_EXrd_i,
    input  wire       ID_EX_MemRead_i,
    output wire       hazard_o
    );

    assign hazard_o = ((ID_EX_MemRead_i && (ID_EXrd_i == IF_IDrs_i || ID_EXrd_i == IF_IDrt_i)) ? 1'b1 : 1'b0);

endmodule

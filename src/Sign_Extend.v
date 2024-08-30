module Sign_Extend(
    input  wire        select_i,
    input  wire [11:0] data0_i,
    input  wire [11:0] data1_i,
    output wire [31:0] data_o     
    );

    assign data_o = (select_i) ? {{20{data1_i[11]}}, data1_i} : {{20{data0_i[11]}}, data0_i} ; 

endmodule
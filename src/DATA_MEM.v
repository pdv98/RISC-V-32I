module DATA_MEM(   
    input  wire        CLK,         // <- external
    input  wire        nRESET,      // <- external
    input  wire [31:0] addr_i,      // <- EX_MEM
    input  wire [31:0] data_i,      // <- EX_MEM
    input  wire        MemWrite_i,  // <- EX_MEM
    input  wire        MemRead_i,   // <- EX_MEM
    output wire [31:0] data_o,       // -> MEM_WB
    output wire [31:0] mem_data_0,  // Memory data at address 0
    output wire [31:0] mem_data_1,  // Memory data at address 4
    output wire [31:0] mem_data_2,  // Memory data at address 8
    output wire [31:0] mem_data_3,  // Memory data at address 12
    output wire [31:0] mem_data_4,  // Memory data at address 16
    output wire [31:0] mem_data_5,  // Memory data at address 20
    output wire [31:0] mem_data_6,  // Memory data at address 24
    output wire [31:0] mem_data_7   // Memory data at address 28
);

    reg [7:0] memory [0:31];    // 8 x 32 memory
    wire [31:0] read_data;

    assign read_data  = {memory[addr_i +32'd3], memory[addr_i +32'd2], memory[addr_i +32'd1], memory[addr_i ]};
    assign data_o     = (MemRead_i) ? read_data : 32'b0;

    assign mem_data_0 = {memory[3], memory[2], memory[1], memory[0]};
    assign mem_data_1 = {memory[7], memory[6], memory[5], memory[4]};
    assign mem_data_2 = {memory[11], memory[10], memory[9], memory[8]};
    assign mem_data_3 = {memory[15], memory[14], memory[13], memory[12]};
    assign mem_data_4 = {memory[19], memory[18], memory[17], memory[16]};
    assign mem_data_5 = {memory[23], memory[22], memory[21], memory[20]};
    assign mem_data_6 = {memory[27], memory[26], memory[25], memory[24]};
    assign mem_data_7 = {memory[31], memory[30], memory[29], memory[28]};

    initial 
    begin
        $readmemh("datamemory.hex", memory);
    end

    integer i;

    always @(posedge CLK or negedge nRESET)
    begin
        if(~nRESET)
            $readmemh("datamemory.hex", memory);
        else if(MemWrite_i)
        begin
            memory[addr_i +32'd3] <= data_i[31:24];
            memory[addr_i +32'd2] <= data_i[23:16];
            memory[addr_i +32'd1] <= data_i[15: 8];
            memory[addr_i       ] <= data_i[ 7: 0];
        end
    end

endmodule


module tb_CPU_Top;

    reg CLK;
    reg nRESET;

    CPU_Top uCPU_Top(
        .CLK(CLK), 
        .nRESET(nRESET)
    );

    initial begin
        #10
        nRESET = 1'b1;
        CLK = 1'b0;
        #10
        nRESET = 1'b0;
        CLK = 1'b1;
        #10
        nRESET = 1'b1;
        forever #10 CLK = ~CLK;
    end
    initial begin
        $dumpvars;
        #1000
        $dumpflush;
        $finish;
    end

endmodule
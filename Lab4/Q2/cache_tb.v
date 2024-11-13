module cache_tb;

    reg clk, pstrobe, prw;
    reg [15:0] paddress;
    reg [31:0] pdata_in;
    wire pready;
    wire [31:0] pdata_out;

    cache cache_instance(
        .clk(clk),
        .pstrobe(pstrobe),
        .prw(prw),
        .paddress(paddress),
        .pdata_in(pdata_in),
        .pdata_out(pdata_out),
        .pready(pready)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        pstrobe = 1; prw = 0;
        #10 paddress = 16'h0012;  #10;
        $display("Address 0x0012 Read: Data=%h", pdata_out);
        
        #10 paddress = 16'h0045; #10;
        $display("Address 0x0045 Read: Data=%h", pdata_out);

        #10 paddress = 16'h0076; #10;
        $display("Address 0x0076 Read: Data=%h", pdata_out);

        #10 paddress = 16'h0066; #10;
        $display("Address 0x0066 Read: Data=%h", pdata_out);

        #10 paddress = 16'h0076; #10;
        $display("Address 0x0076 Read: Data=%h", pdata_out);

        #10 paddress = 16'h0059; #10;

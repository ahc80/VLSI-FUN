module cache_tb;

    // Testbench signals for cache control
    reg clk, pstrobe, prw;
    reg [15:0] paddress;
    reg [31:0] pdata_in;
    wire pready;
    wire [31:0] pdata_out;

    // Instantiate the cache (assuming mixed-language support)
    cache cache_instance(
        .clk(clk),
        .pstrobe(pstrobe),
        .prw(prw),
        .paddress(paddress),
        .pdata_in(pdata_in),
        .pdata_out(pdata_out),
        .pready(pready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period
    end

    // Test sequence
    initial begin
        $display("Starting Cache Test...");

        // 1. Write data to a specific address (causes cache miss and stores in cache with dirty bit)
        pstrobe = 1; prw = 1; paddress = 16'h0010; pdata_in = 32'hAABBCCDD;
        #10 pstrobe = 0;
        #20;
        $display("Write to address 0x0010: Data=0x%h, Dirty Bit Set", pdata_in);

        // 2. Read from the same address (should be a cache hit)
        pstrobe = 1; prw = 0; paddress = 16'h0010;
        #10 pstrobe = 0;
        #20;
        $display("Read from address 0x0010: Data=0x%h, Cache Hit", pdata_out);

        // 3. Read from an address that’s not in cache (cache miss, loads from memory)
        pstrobe = 1; prw = 0; paddress = 16'h0020;
        #10 pstrobe = 0;
        #50;  // Longer delay for cache miss
        $display("Read from address 0x0020: Data=0x%h, Cache Miss", pdata_out);

        // 4. Write to a new address (cache miss, updates cache with dirty bit set)
        pstrobe = 1; prw = 1; paddress = 16'h0031; pdata_in = 32'h12345678;
        #10 pstrobe = 0;
        #20;
        $display("Write to address 0x0031: Data=0x%h, Dirty Bit Set", pdata_in);

        // 5. Read from a recently written address to test cache hit
        pstrobe = 1; prw = 0; paddress = 16'h0031;
        #10 pstrobe = 0;
        #20;
        $display("Read from address 0x0031: Data=0x%h, Cache Hit", pdata_out);

        // 6. Write to an address that will cause eviction of a cache line (index conflict)
        pstrobe = 1; prw = 1; paddress = 16'h0080; pdata_in = 32'hDEADBEEF;
        #10 pstrobe = 0;
        #20;
        $display("Write to address 0x0080: Data=0x%h, Eviction Occurred if Necessary", pdata_in);

        // 7. Read from a previously evicted address (cache miss, reloads from memory)
        pstrobe = 1; prw = 0; paddress = 16'h0010;
        #10 pstrobe = 0;
        #50;  // Longer delay for cache miss
        $display("Read from address 0x0010: Data=0x%h, Cache Miss", pdata_out);

        // End of test
        $display("Cache Test Completed.");
        $stop;
    end

endmodule

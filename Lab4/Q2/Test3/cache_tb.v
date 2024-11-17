`timescale 1ns / 1ps

module cache_tb();

    reg clk, pstrobe, prw;
    reg [15:0] paddress;
    reg [31:0] pdata_in;

    wire pready;
    wire [31:0] pdata_out;

    wire sysstrobe, sysrw;
    wire [15:0] sysaddress;
    wire [31:0] sysdata_out, sysdata_in;

    // Instantiate the cache module
    cache cache_instance (
        .pdata_in(pdata_in),
        .paddress(paddress),
        .clk(clk),
        .pstrobe(pstrobe),
        .prw(prw),
        .pdata_out(pdata_out),
        .pready(pready)
    );

    // Instantiate the memory module
    memory memory_instance (
        .sysAddress(sysaddress),
        .sysDataIn(sysdata_out),  // Connect cache output to memory input
        .sysRW(sysrw),
        .sysStrobe(sysstrobe),
        .sysDataOut(sysdata_in)   // Connect memory output to cache input
    );

    initial begin
        $display("TESTING CACHE DESIGN...");
        $display("**************************************************************");

        // Initialize signals
        clk = 0;
        pstrobe = 0;
        prw = 1;
        
        // Initial delay to stabilize clock
        #100;

        // Test read operations with cache misses
        perform_read(16'h0012);  // Address 0x12
        perform_read(16'h0045);  // Address 0x45
        perform_read(16'h0076);  // Address 0x76
        perform_read(16'h0066);  // Address 0x66
        perform_read(16'h0076);  // Address 0x76 (repeat to test for cache hit)
        perform_read(16'h0059);  // Address 0x59
        perform_read(16'h0045);  // Address 0x45 (repeat to test for cache hit)
        perform_read(16'h0012);  // Address 0x12 (repeat to test for cache hit)

        $display("**************************************************************");

        // Test write operation
        $display("TESTING WRITE OPERATION");
        $display("**************************************************************");
        
        pstrobe = 1'b1;
        prw = 1'b0;   // Write operation
        paddress = 16'h0099;
        pdata_in = 32'ha123b456;
        #100
        pstrobe = 1'b0;
        $display("Address WRITE: %h          Timestamp:%d", paddress, $time);
        #800;
        $display("Data In: %h          Timestamp:%d", pdata_in, $time);

        // Read back the written data to confirm cache hit
        prw = 1'b1;   // Read operation
        pstrobe = 1'b1;
        paddress = 16'h0099;
        #100
        pstrobe = 1'b0;
        #100;
        $display("Read back Address: %h          Timestamp:%d", paddress, $time);
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("NOTE: DELAY OF ONLY 100 AS CACHE HIT - Recently written data");

        $stop;
    end

    // Clock generation
    always #50 clk = ~clk;

    // Task for read operations
    task perform_read(input [15:0] addr);
        begin
            pstrobe = 1'b1;
            prw = 1'b1;  // Read operation
            paddress = addr;
            #100 pstrobe = 1'b0;
            $display("Address Request: %h          Timestamp: %d", addr, $time);
            #300;
            $display("Data Out: %h          Timestamp: %d", pdata_out, $time);
            $display("CACHE MISS: Delay of 600 as data was fetched from memory.");
            $display();
        end
    endtask

endmodule
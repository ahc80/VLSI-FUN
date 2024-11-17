// Cache_tb_test.v
`timescale 1ns / 1ps

module Cache_tb_test;

    reg clk;
    reg Pstrobe;
    reg Prw;
    reg [15:0] Paddress;
    wire [31:0] Pdata;
    wire Pready;

    // System bus signals
    wire Sysstrobe;
    wire Sysrw;
    wire [15:0] Sysaddress;
    wire [31:0] Sysdata;

    // Instantiate the cache (using VHDL module)
    Cache cache_inst (
        .clk(clk),
        .Pstrobe(Pstrobe),
        .Prw(Prw),
        .Paddress(Paddress),
        .Pdata(Pdata),
        .Pready(Pready),
        .Sysstrobe(Sysstrobe),
        .Sysrw(Sysrw),
        .Sysaddress(Sysaddress),
        .Sysdata(Sysdata)
    );

    // Instantiate the memory
    Memory memory_inst (
        .clk(clk),
        .strobe(Sysstrobe),
        .rw(Sysrw),
        .address(Sysaddress),
        .data(Sysdata)
    );

    // Data bus driving
    reg [31:0] Pdata_reg;
    reg Pdata_en;
    assign Pdata = Pdata_en ? Pdata_reg : 32'bz;

    initial begin
        // Initialize clock
        clk = 0;
        forever #50 clk = ~clk; // 100 units clock period
    end

    initial begin
        // Initialize signals
        Pstrobe = 0;
        Prw = 1; // Default to read
        Paddress = 0;
        Pdata_reg = 32'h00000000;
        Pdata_en = 0;

        // Wait for global reset
        #100;

        // Sequence of addresses to test
        reg [15:0] address_sequence [0:7];
        address_sequence[0] = 16'd12; // 0x000C
        address_sequence[1] = 16'd69; // 0x0045
        address_sequence[2] = 16'd118; // 0x0076
        address_sequence[3] = 16'd102; // 0x0066
        address_sequence[4] = 16'd118; // 0x0076
        address_sequence[5] = 16'd89; // 0x0059
        address_sequence[6] = 16'd69; // 0x0045
        address_sequence[7] = 16'd12; // 0x000C

        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            // Perform read operation
            @(posedge clk);
            Pstrobe <= 1;
            Prw <= 1; // Read
            Paddress <= address_sequence[i];
            Pdata_en <= 0;
            @(posedge clk);
            Pstrobe <= 0;
            // Wait for Pready
            wait (Pready == 1);
            // Read data from Pdata
            $display("Time %0t: Read Address %h, Data %h", $time, Paddress, Pdata);
            @(posedge clk);
        end

        // Finish simulation
        #200;
        $finish;
    end

endmodule

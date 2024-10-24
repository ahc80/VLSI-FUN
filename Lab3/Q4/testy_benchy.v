module testy_benchy ();

    reg clk;
    reg reading;
    reg [11:0] address;
    wire[31:0] data_to_mem;
    wire[31:0] data_to_cpu;

    reg [31:0] accumulator;

    // tasks

    task read_address(
        input [11:0] address_in
    );
        begin
            reading     = 1'b1;
            address     = address_in;
            accumulator = data_to_cpu;
        end
    endtask


    memory mem(
        reading,
        clk,
        address,
        data_to_mem,
        data_to_cpu
    );

    initial begin
        clk = 1'b0;
        reading = 1'b1;
        address = 12'b0;

        #300 $finish;
    end

    always begin
        #10 clk = ~clk;
    end

    always @(posedge clk ) begin
        if(address < 16) begin
            read_address(address);
            address <= address + 1;
            $display($time, " Address|Val %d|%d", address, accumulator);
        end
    end
    


endmodule
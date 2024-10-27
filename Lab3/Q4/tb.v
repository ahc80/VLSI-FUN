module tb;
reg         clk;
wire        reading;
wire [31:0] data_to_proccessor;
wire [31:0] data_to_memory;
wire [11:0] address;

processor cpu(
    .clk(clk),
    .data_in(data_to_proccessor),
    .reading(reading),
    .program_counter(address),
    .accumulator(data_to_memory)
);

memory mem(
    .reading(reading),
    .clk(clk),
    .address(address),
    .data_in(data_to_memory),
    .data_out(data_to_proccessor)
);


initial begin
    clk = 0;
end

always #10 clk = ~clk;

endmodule
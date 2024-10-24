module memory (
    input             reading, // 1 = read (output a value), 0 = write (write to reg)
    input             clk,
    input      [11:0] address,
    input      [31:0] data_in,
    output reg [31:0] data_out
);
    
    reg [31:0] registers [4095:0];

    integer i;
    initial begin
        for(i=0; i<4096; i=i+1) begin
            registers[i] = 0;
        end
        data_out = 32'd0;
    end

    always @(posedge clk) begin
        if(reading) begin
            data_out <= registers[address];
        end else begin
            registers[address] <= data_in;
        end
    end
endmodule
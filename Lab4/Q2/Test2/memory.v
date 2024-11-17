// Memory.v
module Memory (
    input wire clk,
    input wire strobe,
    input wire rw,               // Read/Write signal: '1' for read, '0' for write
    input wire [15:0] address,   // 16-bit address bus
    inout wire [31:0] data       // 32-bit data bus
);

    reg [31:0] mem [0:255];      // 256 words of 32-bit memory
    reg [31:0] data_out;
    reg data_en;

    assign data = data_en ? data_out : 32'bz; // Tri-state data bus

    always @(posedge clk) begin
        if (strobe) begin
            if (rw) begin
                // Read operation
                data_out <= mem[address[9:2]]; // Using bits [9:2] for word addressing
                data_en <= 1'b1;
            end else begin
                // Write operation
                mem[address[9:2]] <= data;
                data_en <= 1'b0;
            end
        end else begin
            data_en <= 1'b0;
        end
    end

endmodule

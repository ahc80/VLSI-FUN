module processor (
    input         clk,
    input  [31:0] instructions,

    input  [31:0] data_in,

    output [11:0] address,
    output [31:0] data_out
);

    reg [31:0]  IR;
    reg [ 4:0]  PSR; 

endmodule
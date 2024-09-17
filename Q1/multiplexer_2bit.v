// ECSE 318 
// Andrew Chen and Audrey Michel
// This is the 1-bit multiplexer
// 2001 verilog

`timescale 1ns/1ns

module multiplexer_2bit (
    input wire [1:0] A,           // 2-bit Input A
    input wire [1:0] B,           // 2-bit Input B
    input wire Select_bit,        // Select signal
    output wire [1:0] S           // 2-bit Output
);

    // Multiplexer logic: If Select_bit is 1, S = B; If Select_bit is 0, S = A
    assign S = (Select_bit) ? B : A;

endmodule





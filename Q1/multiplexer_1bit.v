// ECSE 318 
// Andrew Chen and Audrey Michel
// This is the 1-bit multiplexer
// 2001 verilog

`timescale 1ns/1ns

module multiplexer_1bit (
    input wire A,            // Input A
    input wire B,            // Input B
    input wire Select,   // Select signal
    output wire Y            // Output
);

    // Multiplexer logic: If Select_bit is 1, S = B; If Select_bit is 0, S = A
    assign Y = (Select) ? B : A;

endmodule

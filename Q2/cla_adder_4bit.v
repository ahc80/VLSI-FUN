// ECSE 318 
// Andrew Chen and Audrey Michel

`timescale 1ps/1fs // Set timescale to 1 picosecond with 1 femtosecond precision

module carry_lookahead_adder (
    input [3:0] A,          // First 4-bit input
    input [3:0] B,          // Second 4-bit input
    input carry_in,         // Input carry
    output [3:0] sum,       // 4-bit sum output
    output carry_out        // Output carry
);

wire [3:0] propagate;       // Propagate signals for each bit
wire [3:0] gen;             // Generate signals for each bit
wire [3:0] carry;           // Carry signals between each bit

// Generate (g) and propagate (p) logic
// Don't want all of the gates to be executed at the same time
assign #10 gen = A & B;     // Generate signal: A AND B
assign #10 propagate = A ^ B;    // Propagate signal: A XOR B

// Look at the Generic CLA provided in the HW1 Sheet
// Carry logic for each bit
//#20 delay bc 2 gates for assign statment, each w #10 delay
assign #20 carry[0] = (carry_in & propagate[0]) | gen[0];        // Carry for bit 0
assign #20 carry[1] = (carry[0] & propagate[1]) | gen[1];        // Carry for bit 1
assign #20 carry[2] = (carry[1] & propagate[2]) | gen[2];        // Carry for bit 2
assign #20 carry[3] = (carry[2] & propagate[3]) | gen[3];        // Carry for bit 3

// Sum logic for each bit
assign #10 sum[0] = carry_in ^ propagate[0];      // Sum for bit 0
assign #10 sum[1] = carry[0] ^ propagate[1];      // Sum for bit 1
assign #10 sum[2] = carry[1] ^ propagate[2];      // Sum for bit 2
assign #10 sum[3] = carry[2] ^ propagate[3];      // Sum for bit 3

// Final carry-out
assign carry_out = carry[3];                      // Carry-out from the most significant bit

endmodule : carry_lookahead_adder

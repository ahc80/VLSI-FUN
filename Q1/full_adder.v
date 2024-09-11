// ECSE 318 
// Andrew Chen and Audrey Michel
// This is the full adder.
//This is in 2001 Verilog

`timescale 1ns/1ns

module full_adder (
    input A,      // First input bit
    input B,      // Second input bit
    input Cin,    // Carry input bit
    output Sum,    // Sum output
    output Cout    // Carry output
);

    wire AxorB;        // Intermediate wire for A XOR B
    wire AandB;        // Intermediate wire for A AND B
    wire AxorBandC;        // Intermediate wire for (A XOR B) AND Cin

    // Structural logic using gates
    xor (AxorB, A, B);              // XOR gate for A and B
    xor (Sum, AxorB, Cin);          // XOR gate for (A XOR B) and Cin
    and (AandB, A, B);              // AND gate for A and B
    and (AxorBandC, AxorB, Cin);          // AND gate for (A XOR B) and Cin
    or  (Cout, AandB, AxorBandC);         // OR gate for carry-out

endmodule

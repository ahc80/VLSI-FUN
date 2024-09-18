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
    xor u_xor1(AxorB, A, B);              // XOR gate for A and B
    xor u_xor2(Sum, AxorB, Cin);          // XOR gate for (A XOR B) and Cin
    
    and u_and1(AandB, A, B);              // AND gate for A and B
    and u_and2(AxorBandC, AxorB, Cin);          // AND gate for (A XOR B) and Cin
    
    or  u_or(Cout, AandB, AxorBandC);         // OR gate for carry-out

endmodule

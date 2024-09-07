module full_adder (
    input  wire A,      // First input bit
    input  wire B,      // Second input bit
    input  wire Cin,    // Carry input bit
    output wire Sum,    // Sum output
    output wire Cout    // Carry output
);

    wire AxorB;        // Intermediate wire for A XOR B
    wire AandB;        // Intermediate wire for A AND B
    wire AxorBandCin;  // Intermediate wire for (A XOR B) AND Cin

    // Structural logic using gates
    xor (AxorB, A, B);              // XOR gate for A and B
    xor (Sum, AxorB, Cin);          // XOR gate for (A XOR B) and Cin
    and (AandB, A, B);              // AND gate for A and B
    and (AxorBandCin, AxorB, Cin);  // AND gate for (A XOR B) and Cin
    or  (Cout, AandB, AxorBandCin); // OR gate for carry-out

endmodule

//This is in 2001 Verilog

module full_adder (
    input  wire A,      // First input bit
    input  wire B,      // Second input bit
    input  wire Cin,    // Carry input bit
    output wire Sum,    // Sum output
    output wire Cout    // Carry output
);

    wire L1;        // Intermediate wire for A XOR B
    wire L2;        // Intermediate wire for A AND B
    wire L3;        // Intermediate wire for (A XOR B) AND Cin

    // Structural logic using gates
    xor (L1, A, B);              // XOR gate for A and B
    xor (Sum, L1, Cin);          // XOR gate for (A XOR B) and Cin
    and (L2, A, B);              // AND gate for A and B
    and (L3, L1, Cin);          // AND gate for (A XOR B) and Cin
    or  (Cout, L2, L3);         // OR gate for carry-out

endmodule

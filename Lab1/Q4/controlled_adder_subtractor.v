`timescale 1ns/1ns

module controlled_adder_substractor (
    input A,
    input B,
    input Diagonal,
    input C_in,

    // There will be no output B, since each
    output C_out,      // Eventually labeled as Q on occasion
    output S
);

    wire B_xor_diagonal;

    xor (B_xor_diagonal, B, Diagonal);

    full_adder FA (
        .A(A),
        .B(B_xor_diagonal),
        .Cin(C_in),
        .Sum(S),
        .Cout(C_out)
    );
    
endmodule
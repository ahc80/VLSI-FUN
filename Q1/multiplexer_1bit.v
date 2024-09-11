// ECSE 318 
// Andrew Chen and Audrey Michel
// This is the 1-bit multiplexer
// 2001 verilog

`timescale 1ns/1ns

module multiplexer_1bit (
    input A, 
    input B, 
    input Select_bit,
    output S,

    // For this multiplexer, a select bit value of 1 will output the A value
);

    wire A_AND_Select;
    wire B_AND_nSelect;
    wire nSelect_bit;

    not u_not(nSelect_bit, Select_bit);

    and u_and1(A_AND_Select, A, Select_bit);
    and u_and2(B_AND_nSelect, B, nSelect_bit);

    or u_or(S, A_AND_Select, B_AND_nSelect);

endmodule
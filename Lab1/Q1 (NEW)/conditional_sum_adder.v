// ECSE 318 
// Andrew Chen and Audrey Michel

module conditional_sum_adder (
    input [7:0] x,  // 8-bit input x
    input [7:0] y,  // 8-bit input y
    input c0,       // Initial carry-in (usually 0)

    output c8,      // Final carry-out
    output [7:0] S  // 8-bit sum output
);

    // Intermediate signals for sums and carries when carry-in = 0 and 1
    wire [7:0] sum0, sum1;       // Sum when carry-in is 0 and when carry-in is 1
    wire [7:0] carry0, carry1;   // Carry when carry-in is 0 and when carry-in is 1
    wire [7:0] carry_mux;        // Selected carry for each stage

    // Stage 0: No multiplexing, carry-in is known (c0)
    full_adder FA_stage0 (
        .A(x[0]),
        .B(y[0]),  
        .Cin(c0),            // Initial carry-in
        .Sum(S[0]),  
        .Cout(carry_mux[0])  // Carry-out from stage 0
    );

    // Stages 1 to 7: Generate two possible sums and carries, use conditional assignments to select the correct one
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin: stage
            // Full adder when carry-in = 0
            full_adder FA_cin0 (
                .A(x[i]),
                .B(y[i]),
                .Cin(1'b0),      // Assume carry-in is 0
                .Sum(sum0[i]),
                .Cout(carry0[i])
            );

            // Full adder when carry-in = 1
            full_adder FA_cin1 (
                .A(x[i]),
                .B(y[i]),
                .Cin(1'b1),      // Assume carry-in is 1
                .Sum(sum1[i]),
                .Cout(carry1[i])
            );

            // Multiplexer for sum
            assign S[i] = carry_mux[i-1] ? sum1[i] : sum0[i];

            // Multiplexer for carry-out
            assign carry_mux[i] = carry_mux[i-1] ? carry1[i] : carry0[i];
        end
    endgenerate

    // Final carry-out after the last stage
    assign c8 = carry_mux[7];

endmodule

// Full adder module
module full_adder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

`timescale 1ns / 1ns

module structural_logic1 (
    input [1:0] X,  // 2-bit input X: X[1] = X1, X[0] = X2
    output Z1, Z2   // Outputs Z1, Z2
);

    // Intermediate signals
    wire S1, S2;
    wire not_X1, not_X2, not_S2;

    // NOT gates
    assign not_X1 = ~X[1];  // X1
    assign not_X2 = ~X[0];  // X2
    assign not_S2 = ~S2;

    // Correct combinational logic for S1 and S2
    assign S1 = (~X[1] & ~X[0]) | (X[1] & X[0]);  // Based on input
    assign S2 = (~X[1] & X[0]) | (X[1] & ~X[0]);  // Based on input

    // Z1 = S1
    assign Z1 = S1;

    // Z2 = X1 * X2 * ~S2 + X1 * ~X2 * S2
    assign Z2 = (X[1] & X[0] & not_S2) | (X[1] & not_X2 & S2);

endmodule

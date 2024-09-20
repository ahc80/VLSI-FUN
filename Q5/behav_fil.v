`timescale 1ns / 1ns

module behavioral_logic1 (
    input [1:0] X,  // 2-bit input X: X[1] = X1, X[0] = X2
    output reg Z1, Z2  // Outputs Z1, Z2
);

    // Intermediate variables S1 and S2
    reg S1, S2;

    always @(*) begin
        // Purely combinational logic for S1 and S2
        S1 = (~X[1] & ~X[0]) | (X[1] & X[0]);  // S1 based on input
        S2 = (~X[1] & X[0]) | (X[1] & ~X[0]);  // S2 based on input

        // Z1 = S1
        Z1 = S1;

        // Z2 = X1 * X2 * ~S2 + X1 * ~X2 * S2
        Z2 = (X[1] & X[0] & ~S2) | (X[1] & ~X[0] & S2);
    end

endmodule

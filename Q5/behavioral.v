// ECSE 318
// Andrew Chen and Audrey Michel

`timescale 1ns / 1ns  // Time unit / time precision

module verilog_Behavioral (
    input X1,
    input X2,
    output reg Z1,
    output reg Z2
);

reg A1, A2, A3, A4, A5, A6;
reg S1, S2;

// Always block for intermediate AND and OR logic
always @(*) begin
    // AND logic
    A1 = ~X1 & S1;
    A2 = S1 & S2;
    A3 = X1 & S2;
    A4 = X1 & X2 & ~S2;
    A5 = X2 & S1;
    A6 = X1 & ~X2 & S2;
    
    // OR logic
    S1 = A1 | A4 | A5;
    S2 = A1 | A2 | A3;
end

// Always block for output assignments
always @(*) begin
    Z1 = S1;
    Z2 = A4 | A6;
end

endmodule

`timescale 1ns / 1ns  // Time unit / time precision

module verilog_Structural (
    input [1:0] X,  // 2-bit input X
    output [1:0] Z  // 2-bit output Z
);

wire A1;
wire A2;
wire A3;
wire A4;
wire A5;
wire A6;

//In descending order for OR Gates
wire S1;
wire S2;

// Referencing X[0] as X1 and X[1] as X2 for clarity
wire X1 = X[0];
wire X2 = X[1];

// AND Logic
assign A1 = ~X1 & S1;
assign A2 = S1 & S2;
assign A3 = X1 & S2;
assign A4 = X1 & X2 & ~S2;
assign A5 = X2 & S1;
assign A6 = X1 & ~X2 & S2;

// OR Logic
assign S1 = A1 | A4 | A5;
assign S2 = A1 | A2 | A3;

// Outputs
assign Z[1] = S1;         // Assign Z1 to Z[1]
assign Z[0] = A4 | A6;    // Assign Z2 to Z[0]

endmodule

`timescale 1ns / 1ns  // Time unit / time precision

module verilog_Behavioral (
    input [1:0] X,  // 2-bit input X
    output reg [1:0] Z  // 2-bit output Z
);

    // Declare intermediate variables
    reg S1, S2;
    reg A1, A2, A3, A4, A5, A6;
    reg X1, X2;  // Declare X1 and X2 as reg to store X values

    always @(*) begin
        // Assigning input X to X1 and X2
        X1 = X[0];
        X2 = X[1];

        // AND Logic
        A1 = ~X1 & S1;
        A2 = S1 & S2;
        A3 = X1 & S2;
        A4 = X1 & X2 & ~S2;
        A5 = X2 & S1;
        A6 = X1 & ~X2 & S2;

        // OR Logic
        S1 = A1 | A4 | A5;
        S2 = A1 | A2 | A3;

        // Output Assignments
        Z[1] = S1;         // Z1 corresponds to Z[1]
        Z[0] = A4 | A6;    // Z2 corresponds to Z[0]
    end

endmodule

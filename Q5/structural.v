`timescale 1ns / 1ns  // Time unit / time precision

//In descending order for AND Gates

module verilog_Structural (
    input X1,
    input X2,
    output Z1,
    output Z2,
);

wire A1,
wire A2,
wire A3,
wire A4,
wire A5,
wire A6,

//In descending order for OR Gates
wire S1,
wire S2,

//AND Logic
assign A1 = ~X1 & S1
assign A2 = S1 & S2
assign A3 = X1 & S2
assign A4 = X1 & X2 & ~S2
assign A5 = X2 & S1
assign A6 = X1 & ~X2 & S2

//OR Logic
assign S1 = A1 | A4 | A5
assign S2 = A1 | A2 | A3

//Outputs
assign Z1 = S1
assign Z2 = A4 | A6

endmodule
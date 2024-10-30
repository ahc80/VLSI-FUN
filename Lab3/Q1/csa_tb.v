// ECSE 318 
// Andrew Chen and Audrey Michel

`timescale 1ns/1ns

module tb_conditional_sum_adder;
    reg [7:0] x;      // 8-bit input x
    reg [7:0] y;      // 8-bit input y
    reg c0;           // Initial carry-in

    wire cOut;        // Final carry-out
    wire [7:0] S;     // 8-bit sum output

    // Instantiate the Conditional Sum Adder (CSA)
    conditionalSumAdder uut (
        .x(x),
        .y(y),
        .c0(c0),
        .cOut(cOut),
        .S(S)
    );

    initial begin
        // Test Case 1: Basic addition to check if initial cOut is stable
        x = 8'd12;
        y = 8'd5;
        c0 = 1'b0;
        #100;
        $display("Expected: 12 + 5 (Cin=0) = 17, Cout=0");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // Test Case 2: Addition with carry-in, ensure no Z or X
        x = 8'd12;
        y = 8'd5;
        c0 = 1'b1;
        #100;
        $display("Expected: 12 + 5 + 1 (Cin=1) = 18, Cout=0");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // Test Case 3: Overflow test for undefined carry-out (cOut should be 1, not Z)
        x = 8'd255;
        y = 8'd1;
        c0 = 1'b0;
        #100;
        $display("Expected: 255 + 1 (Cin=0) = 0, Cout=1 (Overflow)");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // Test Case 4: Carry-in overflow to check if cOut is driven correctly
        x = 8'd255;
        y = 8'd1;
        c0 = 1'b1;
        #100;
        $display("Expected: 255 + 1 + 1 (Cin=1) = 1, Cout=1");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // Test Case 5: Carry-in propagation across bits, focus on cOut and intermediate signals
        x = 8'b11110000;
        y = 8'b00001111;
        c0 = 1'b1;
        #100;
        $display("Expected: 240 + 15 + 1 (Cin=1) = 256, Sum=0, Cout=1");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // Additional edge case: check small values that may impact cOut stability
        x = 8'd1;
        y = 8'd1;
        c0 = 1'b0;
        #100;
        $display("Expected: 1 + 1 (Cin=0) = 2, Cout=0");
        $display("Binary  : A: %b + B: %b (Cin=%b) = Sum: %b (Cout=%b)", x, y, c0, S, cOut);
        $display("Actual  : A: %d + B: %d (Cin=%d) = Sum: %d (Cout=%d)", x, y, c0, S, cOut);
        $display("--");

        // End the simulation
        $stop;
    end
endmodule

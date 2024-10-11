// ECSE 318 
// Andrew Chen and Audrey Michel

`timescale 1ns/1ns

module tb_conditional_sum_adder;
    reg [7:0] x;      // 8-bit input x
    reg [7:0] y;      // 8-bit input y
    reg c0;           // Initial carry-in

    wire c8;          // Final carry-out
    wire [7:0] S;     // 8-bit sum output

    // Instantiate the Conditional Sum Adder (CSA)
    conditional_sum_adder uut (
        .x(x),
        .y(y),
        .c0(c0),
        .c8(c8),
        .S(S)
    );

    initial begin
        // Test Case 1: Simple addition without carry-in
        // Expected: 12 + 5 = 17, Carry-out = 0
        x = 12;  // Decimal value 12
        y = 5;   // Decimal value 5
        c0 = 1'b0;  // No carry-in
        #100;
        $display("Expected: 12 + 5 (Cin=0) = 17, Cout=0");
        $display("Binary  : A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", x, y, c0, S, c8);  // Binary format
        $display("Actual  : A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", x, y, c0, S, c8);
        $display("--");

        // Test Case 2: Addition with carry-in
        // Expected: 12 + 5 + 1 = 18, Carry-out = 0
        x = 12;  // Decimal value 12
        y = 5;   // Decimal value 5
        c0 = 1'b1;  // With carry-in
        #100;
        $display("Expected: 12 + 5 + 1 (Cin=1) = 18, Cout=0");
        $display("Binary  : A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", x, y, c0, S, c8);  // Binary format
        $display("Actual  : A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", x, y, c0, S, c8);
        $display("--");

        // Test Case 3: Overflow case
        // Expected: 255 + 1 = 256, Sum = 0, Carry-out = 1
        x = 255;  // Decimal value 255
        y = 1;    // Decimal value 1
        c0 = 1'b0;  // No carry-in
        #100;
        $display("Expected: 255 + 1 (Cin=0) = 0, Cout=1 (Overflow)");
        $display("Binary  : A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", x, y, c0, S, c8);  // Binary format
        $display("Actual  : A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", x, y, c0, S, c8);
        $display("--");

        // Test Case 4: Addition of 110 and 85
        // Expected: 110 + 85 = 195, Carry-out = 0
        x = 110;  // Decimal value 110
        y = 85;   // Decimal value 85
        c0 = 1'b0;  // No carry-in
        #100;
        $display("Expected: 110 + 85 (Cin=0) = 195, Cout=0");
        $display("Binary  : A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", x, y, c0, S, c8);  // Binary format
        $display("Actual  : A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", x, y, c0, S, c8);
        $display("--");

        // Test Case 5: Both operands zero
        // Expected: 0 + 0 = 0, Carry-out = 0
        x = 0;  // Decimal value 0
        y = 0;  // Decimal value 0
        c0 = 1'b0;  // No carry-in
        #100;
        $display("Expected: 0 + 0 (Cin=0) = 0, Cout=0");
        $display("Binary  : A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", x, y, c0, S, c8);  // Binary format
        $display("Actual  : A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", x, y, c0, S, c8);

        // End the simulation
        $stop;
    end
endmodule
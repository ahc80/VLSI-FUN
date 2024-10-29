`timescale 1ns/1ns

module tb_of_divider ();

    // Main signals
    wire [3:0] Q; // Quotient
    wire [3:0] R; // Remainder
    reg  [3:0] M; // Divisor
    reg  [6:0] D; // Dividend

    // Expected values for comparison
    reg [3:0] expected_Q;
    reg [3:0] expected_R;

    // Debugging signals for intermediate outputs
    wire [4:0] debug_cas_array_sum;
    wire [3:0] debug_Q_wire;

    // Instantiate the DUT (long_divider)
    long_divider UUT (
        .M(M),
        .D(D),
        .Q(Q),
        .R(R),
        .debug_cas_array_sum(debug_cas_array_sum),
        .debug_Q_wire(debug_Q_wire)
    );

    // Test process
    initial begin : Testing
        // Test case 1: 7 / 2
        D = 7'b0000111;
        M = 4'b0010;
        expected_Q = 4'b0011;
        expected_R = 4'b0001;
        #50;
        $display("Test case 7/2: Quotient: %b, Remainder: %b", Q, R);
        $display("Expected Quotient: %b | Expected Remainder: %b", expected_Q, expected_R);
        $display("************************************************");
        #50;

        // Test case 2: 6 / 2
        D = 7'b0000110;
        M = 4'b0010;
        expected_Q = 4'b0011;
        expected_R = 4'b0000;
        #50;
        $display("Test case 6/2: Quotient: %b, Remainder: %b", Q, R);
        $display("Expected Quotient: %b | Expected Remainder: %b", expected_Q, expected_R);
        $display("************************************************");
        #50;

        // Test case 3: 9 / 4
        D = 7'b0001001;
        M = 4'b0100;
        expected_Q = 4'b0010;
        expected_R = 4'b0001;
        #50;
        $display("Test case 9/4: Quotient: %b, Remainder: %b", Q, R);
        $display("Expected Quotient: %b | Expected Remainder: %b", expected_Q, expected_R);
        $display("************************************************");
        #50;

        // Test case 4: 12 / 5
        D = 7'b0001100;
        M = 4'b0101;
        expected_Q = 4'b0010;
        expected_R = 4'b0010;
        #50;
        $display("Test case 12/5: Quotient: %b, Remainder: %b", Q, R);
        $display("Expected Quotient: %b | Expected Remainder: %b", expected_Q, expected_R);
        $display("************************************************");
        #50;

        $stop;
    end

endmodule

`timescale 1ns/1ns

module tb ();

    reg X1;
    reg X2;

    wire Z1_behav, Z2_behav;
    wire Z1_struc, Z2_struc;

    // Behavioral model instantiation (connect Z1 and Z2)
    behavioral_logic1 bhv (
        .X({X1, X2}),
        .Z1(Z1_behav),
        .Z2(Z2_behav)
    );

    // Structural model instantiation (connect Z1 and Z2)
    structural_logic1 strc (
        .X({X1, X2}),
        .Z1(Z1_struc),
        .Z2(Z2_struc)
    );

    initial begin
        //
        // Testing procedure key:
        // X1 X2 | Time | Behav: Z1 Z2 | Struct: Z1 Z2 | [Expected Z1 Z2]
        //

        $display("Begin testing. Key: X1 X2 | Time | Behav: Z1 Z2 | Struct: Z1 Z2 | [Expected Z1 Z2]");

        // First run
        // Test case 1: X1 = 0, X2 = 0 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 2: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 3: X1 = 1, X2 = 1 | Expected: 11
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 11", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 4: X1 = 0, X2 = 1 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 5: X1 = 0, X2 = 0 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 6: X1 = 1, X2 = 0 | Expected: 01
        X1 = 1'b1;
        X2 = 1'b0;
        #50 $display("%0t | 10 | Behav: %b%b | Struct: %b%b | Expected: 01", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 7: X1 = 1, X2 = 1 | Expected: 00
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 8: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Second run (repeating)
        $display("---- Repeating the tests (Second Time) ----");

        // Test case 1: X1 = 0, X2 = 0 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 2: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 3: X1 = 1, X2 = 1 | Expected: 11
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 11", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 4: X1 = 0, X2 = 1 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 5: X1 = 0, X2 = 0 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 6: X1 = 1, X2 = 0 | Expected: 01
        X1 = 1'b1;
        X2 = 1'b0;
        #50 $display("%0t | 10 | Behav: %b%b | Struct: %b%b | Expected: 01", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 7: X1 = 1, X2 = 1 | Expected: 00
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        // Test case 8: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Z1_behav, Z2_behav, Z1_struc, Z2_struc);

        $display("All tests complete.");
    end

endmodule

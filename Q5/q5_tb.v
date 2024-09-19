`timescale 1ns/1ns

module tb_of_q_five ();

    reg X1;
    reg X2;

    wire [1:0] Zstruc;
    wire [1:0] Zbehav;

    verilog_Behavioral bhv (
        .X1(X1),
        .X2(X1),
        .Z1(Zbehav[1]),
        .Z2(Zbehav[2])
    );

    verilog_Structural strc (
        .X1(X1),
        .X2(X2),
        .Z1(Zstruc[1]),
        .Z2(Zstruc[2])
    );

    initial begin
        //
        // Testing procedure key:
        // X1 X2 | Behav: Z1 Z2 | Struct: Z1 Z2 | [Expected Z1 Z2]
        //

        $display("Begin testing. Key: X1 X2 | Time | Behav: Z1 Z2 | Struct: Z1 Z2 | [Expected Z1 Z2]");

        // First run
        // Test case 1: X1 = 0, X2 = 0 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 2: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 3: X1 = 1, X2 = 1 | Expected: 11
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 11", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 4: X1 = 0, X2 = 1 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 5: X1 = 0, X2 = 0 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 6: X1 = 1, X2 = 0 | Expected: 01
        X1 = 1'b1;
        X2 = 1'b0;
        #50 $display("%0t | 10 | Behav: %b%b | Struct: %b%b | Expected: 01", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 7: X1 = 1, X2 = 1 | Expected: 00
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 8: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Second run (repeating)
        $display("---- Repeating the tests (Second Time) ----");

        // Test case 1: X1 = 0, X2 = 0 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 2: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 3: X1 = 1, X2 = 1 | Expected: 11
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 11", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 4: X1 = 0, X2 = 1 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 5: X1 = 0, X2 = 0 | Expected: 10
        X1 = 1'b0;
        X2 = 1'b0;
        #50 $display("%0t | 00 | Behav: %b%b | Struct: %b%b | Expected: 10", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 6: X1 = 1, X2 = 0 | Expected: 01
        X1 = 1'b1;
        X2 = 1'b0;
        #50 $display("%0t | 10 | Behav: %b%b | Struct: %b%b | Expected: 01", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 7: X1 = 1, X2 = 1 | Expected: 00
        X1 = 1'b1;
        X2 = 1'b1;
        #50 $display("%0t | 11 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        // Test case 8: X1 = 0, X2 = 1 | Expected: 00
        X1 = 1'b0;
        X2 = 1'b1;
        #50 $display("%0t | 01 | Behav: %b%b | Struct: %b%b | Expected: 00", $time, Zbehav[1], Zbehav[0], Zstruc[1], Zstruc[0]);

        $display("All tests complete.");
    end

endmodule

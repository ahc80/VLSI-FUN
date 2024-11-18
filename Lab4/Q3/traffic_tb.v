module TrafficLightTB;

    // Declare input and output ports for the test bench
    reg clk, reset, sa, sb;
    wire ga, gb, ya, yb, ra, rb;

    // Instantiate the traffic light FSM module
    TrafficLightController traffic_light_instance(
        .clk(clk),
        .reset(reset),
        .Sa(sa),
        .Sb(sb),
        .Ga(ga),
        .Ya(ya),
        .Ra(ra),
        .Gb(gb),
        .Yb(yb),
        .Rb(rb)
    );

    // Generate a clock signal with a 10-time unit period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize the clock and reset signals
        clk = 0;
        reset = 1;
        sa = 0;
        sb = 0;

        // Apply reset
        #20 reset = 0;
        $display("Time: %0t - Reset complete, FSM starts at initial state", $time);

        // Test Case 1: Simulate car arrival on "A" street
        #30 sa = 1;
        $display("Time: %0t - Test Case 1: Car on 'A' street (Sa=1)", $time);

        #210 sa = 0;
        $display("Time: %0t - Test Case 1 complete: Car left 'A' street (Sa=0)", $time);

        // Display traffic light status
        $display("  Traffic Light Status: Ga=%b, Ya=%b, Ra=%b, Gb=%b, Yb=%b, Rb=%b", ga, ya, ra, gb, yb, rb);

        // Test Case 2: Simulate car arrival on "B" street
        #40 sb = 1;
        $display("Time: %0t - Test Case 2: Car on 'B' street (Sb=1)", $time);

        #90 sb = 0;
        $display("Time: %0t - Test Case 2 complete: Car left 'B' street (Sb=0)", $time);

        // Display traffic light status
        $display("  Traffic Light Status: Ga=%b, Ya=%b, Ra=%b, Gb=%b, Yb=%b, Rb=%b", ga, ya, ra, gb, yb, rb);

        // Test Case 3: Simulate extended green light for "B" street
        #45 sb = 1;
        $display("Time: %0t - Test Case 3: Extended green for 'B' street (Sb=1)", $time);

        #160 sb = 0;
        $display("Time: %0t - Test Case 3 complete: Car left 'B' street (Sb=0)", $time);

        // Display traffic light status
        $display("  Traffic Light Status: Ga=%b, Ya=%b, Ra=%b, Gb=%b, Yb=%b, Rb=%b", ga, ya, ra, gb, yb, rb);

        // Test Case 4: Reactivate "A" street after "B" street
        #55 sa = 1;
        $display("Time: %0t - Test Case 4: Car on 'A' street again (Sa=1)", $time);

        #210 sa = 0;
        $display("Time: %0t - Test Case 4 complete: Car left 'A' street (Sa=0)", $time);

        // Display traffic light status
        $display("  Traffic Light Status: Ga=%b, Ya=%b, Ra=%b, Gb=%b, Yb=%b, Rb=%b", ga, ya, ra, gb, yb, rb);

        // Additional Scenario: Reactivate both "A" and "B" for overlapping case
        #50 sa = 1; sb = 1;
        $display("Time: %0t - Additional Scenario: Cars on both 'A' and 'B' streets (Sa=1, Sb=1)", $time);

        #110 sa = 0; sb = 0;
        $display("Time: %0t - Additional Scenario complete: Cars left 'A' and 'B' streets (Sa=0, Sb=0)", $time);

        // Display traffic light status
        $display("  Traffic Light Status: Ga=%b, Ya=%b, Ra=%b, Gb=%b, Yb=%b, Rb=%b", ga, ya, ra, gb, yb, rb);

        // End the simulation
        #20 $display("Time: %0t - End of simulation", $time);
        $stop;
    end

endmodule

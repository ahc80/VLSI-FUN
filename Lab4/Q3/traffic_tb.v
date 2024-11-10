module TrafficLightTB;

    // Declare input and output ports for the test bench
    reg clk, reset, sa, sb;
    wire ga, gb, ya, yb, ra, rb;

    // Instantiate the traffic light FSM module
    TrafficLight traffic_light_instance(
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
        #10 reset = 0;

        // Test Case 1: Simulate car arrival on "A" street
        #20 sa = 1;
        #200 sa = 0;

        // Test Case 2: Simulate car arrival on "B" street
        #20 sb = 1;
        #50 sb = 0;

        // Test Case 3: Simulate extended green light for "B" street
        #20 sb = 1;
        #150 sb = 0;

        // Test Case 4: Reactivate "A" street after "B" street
        #20 sa = 1;
        #200 sa = 0;

        // Additional Scenario: Reactivate both "A" and "B" for overlapping case
        #20 sa = 1; sb = 1;
        #100 sa = 0; sb = 0;

        // End the simulation
        #10 $stop;
    end

endmodule

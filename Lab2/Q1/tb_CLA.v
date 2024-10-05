//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2
`timescale 1ps/1fs // Set timescale to 1 picosecond with 1 femtosecond precision
module cla16bit_tb;

    reg [15:0] a;     // Input A
    reg [15:0] b;     // Input B
    reg c_in;         // Carry-in signal (external input)

    wire [15:0] s;    // Sum output
    wire c_out;       // Carry-out signal

    // Instantiate the CLA module
    cla16bit cla_instance(
        .A(a),
        .B(b),
        .cin(c_in),    // Carry-in connected here
        .SUM(s),
        .C_OUT(c_out)
    );

    // Testbench to run the tests
    initial begin
        $display("LONGEST PROPAGATION DELAY TEST:");
        a = 16'h0001;
        b = 16'h0001;
        c_in = 1'b0;   // Test with carry-in = 0
        #500;          // Wait for 500 time units
        $display("A: %b + B: %b (c_in=%b) = Sum: %b (c_out=%b)", a, b, c_in, s, c_out);
        $display("A: %d + B: %d (c_in=%d) = Sum: %d (c_out=%d)", $signed(a), $signed(b), c_in, $signed(s), c_out);
        $display;

        $display("Testing Addition Functionality with Carry-in = 0:");
        a = 16'hffff;
        b = 16'h0001;
        c_in = 1'b0;   // Test with carry-in = 0
        #100;          // Wait for 100 time units
        $display("A: %b + B: %b (c_in=%b) = Sum: %b (c_out=%b)", a, b, c_in, s, c_out);
        $display("A: %d + B: %d (c_in=%d) = Sum: %d (c_out=%d)", $signed(a), $signed(b), c_in, $signed(s), c_out);
        $display;

        $display("Testing Addition Functionality with Carry-in = 1:");
        a = 16'hdf32;
        b = 16'h93b6;
        c_in = 1'b1;   // Test with carry-in = 1
        #100;          // Wait for 100 time units
        $display("A: %b + B: %b (c_in=%b) = Sum: %b (c_out=%b)", a, b, c_in, s, c_out);
        $display("A: %d + B: %d (c_in=%d) = Sum: %d (c_out=%d)", $signed(a), $signed(b), c_in, $signed(s), c_out);
        $display;
    end

endmodule

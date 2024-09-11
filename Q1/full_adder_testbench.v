// ECSE 318 
// Andrew Chen and Audrey Michel
// This is the test bench for the full adder. 

`timescale 1ns / 1ns  // Time unit / time precision

module full_adder_test_bench;

    // Inputs to the full adder
    reg A;
    reg B;
    reg Cin;
    
    // Outputs from the full adder
    wire Sum;
    wire Cout;
    
    // Instantiate the full adder
    full_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );
    
    // Test stimulus
    initial begin
        // Monitor output changes
        $monitor("At time %t: A = %b, B = %b, Cin = %b -> Sum = %b, Cout = %b", 
                 $time, A, B, Cin, Sum, Cout);
        
        // Apply inputs
        A = 0; B = 0; Cin = 0; #10;  // Expected Sum=0, Cout=0
        A = 0; B = 0; Cin = 1; #10;  // Expected Sum=1, Cout=0
        A = 0; B = 1; Cin = 0; #10;  // Expected Sum=1, Cout=0
        A = 0; B = 1; Cin = 1; #10;  // Expected Sum=0, Cout=1
        A = 1; B = 0; Cin = 0; #10;  // Expected Sum=1, Cout=0
        A = 1; B = 0; Cin = 1; #10;  // Expected Sum=0, Cout=1
        A = 1; B = 1; Cin = 0; #10;  // Expected Sum=0, Cout=1
        A = 1; B = 1; Cin = 1; #10;  // Expected Sum=1, Cout=1

        // End simulation
        $finish;
    end

endmodule

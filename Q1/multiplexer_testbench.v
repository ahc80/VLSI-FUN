`timescale 1ns / 1ps //Time unit /time precision

module multiplexer_test_bench;

    //Inputs
    reg A;
    reg B;
    reg Select;

    //Outputs
    wire Out;

    //Instantiate
    multiplexer_1bit uut (
        .A(A),
        .B(B),
        .Select(Select),
        .Out(Out)
    )

    // Test stimulus
    initial begin
        // Monitor changes in inputs and output
        $monitor("At time %t: A = %b, B = %b, Select = %b -> Out = %b", 
                 $time, A, B, Select, Out);

        // Apply test inputs
        A = 0; B = 0; Select = 0; #10;  // Expected Out = A (0)
        A = 0; B = 1; Select = 0; #10;  // Expected Out = A (0)
        A = 1; B = 0; Select = 0; #10;  // Expected Out = A (1)
        A = 1; B = 1; Select = 0; #10;  // Expected Out = A (1)
        
        A = 0; B = 0; Select = 1; #10;  // Expected Out = B (0)
        A = 0; B = 1; Select = 1; #10;  // Expected Out = B (1)
        A = 1; B = 0; Select = 1; #10;  // Expected Out = B (0)
        A = 1; B = 1; Select = 1; #10;  // Expected Out = B (1)

        // End the simulation
        $finish;
    end

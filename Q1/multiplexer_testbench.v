`timescale 1ns / 1ps //Time unit /time precision

module multiplexer_test_bench;

    //Inputs
    reg Sum_1;
    reg Sum_2;
    reg Cout_1;
    reg Cout_2;

    //Outputs
    wire Carry;
    wire Sum;

    //Instantiate
    multiplexer_1bit uut (
        .
    )

    //Test simulation
    initial begin
        //Monitor
        $monitor("At time%t: Sum_1 = %b, Sum_2 = %b, Cout_1 = %b, Cout_2 = %b", $time, A, B, Cin, Sum, Cout);

        //Apply Inputs

    end

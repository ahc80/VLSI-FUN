// ECSE 318 
// Andrew Chen and Audrey Michel
// This one of the top-level modules for the circuit that holds 
// 2 Fulls adders, 4 multiplexers, 2 concatenators.

`timescale 1ns/1ns

module red_box (
    input x2, //Going to make the variables based off of the first "red_box"
    input y2, //But they should apply to all of the "red_box".
    input x3,
    input y3,
    output [1:0] concat_mux1,
    output mux2,
    output [1:0] concat_mux3,
    output mux4
);

    wire sum1, cout1;  // FA1 outputs
    wire sum2, cout2;  // FA2 outputs
    wire sum3, cout3;  // FA3 outputs
    wire sum4, cout4;  // FA4 outputs

    wire mux_out1, mux_out2;  // MUX1, MUX2 outputs
    wire mux_out3, mux_out4;  // MUX3, MUX4 outputs

    // Instantiate Full Adders

    //  Cin = 1 for FA1
    //  Cin = 0 for FA2
    //  Cin = 1 for FA3
    //  Cin = 0 for FA4

    full_adder FA1 (
        .A(x2),
        .B(y2),  
        .Cin(1'b1),  // Cin = 1 for FA1
        .Sum(sum1),
        .Cout(cout1)
    );

    full_adder FA2 (
        .A(x2),
        .B(y2),  
        .Cin(1'b0),  // Cin = 0 for FA2
        .Sum(sum2),
        .Cout(cout2)
    );

    full_adder FA3 (
        .A(x3),
        .B(y3),  
        .Cin(1'b1),  // Cin = 1 for FA3
        .Sum(sum3),
        .Cout(cout3)
    );

    full_adder FA4 (
        .A(x3),
        .B(y3),  
        .Cin(1'b0),  // Cin = 0 for FA4
        .Sum(sum4),
        .Cout(cout4)
    );

    // Instantiate MUX1 (controlled by FA1 Cout)
    multiplexer_1bit MUX1 (
        .A(sum3),  // Input from FA3 Sum
        .B(sum4),  // Input from FA4 Sum
        .Select(cout1),  // Cout from FA1
        .Y(mux_out1)
    );

    // Instantiate MUX2 (controlled by FA1 Cout)
    multiplexer_1bit MUX2 (
        .A(cout3),  // Input from FA3 Cout
        .B(cout4),  // Input from FA4 Cout
        .Select(cout1),  // Cout from FA1
        .Y(mux_out2)
    );

    // Instantiate MUX3 (controlled by FA2 Cout)
    multiplexer_1bit MUX3 (
        .A(sum3),  // Input from FA3 Sum
        .B(sum4),  // Input from FA4 Sum
        .Select(cout2),  // Cout from FA2
        .Y(mux_out3)
    );

    // Instantiate MUX4 (controlled by FA2 Cout)
    multiplexer_1bit MUX4 (
        .A(cout3),  // Input from FA3 Cout
        .B(cout4),  // Input from FA4 Cout
        .Select(cout2),  // Cout from FA2
        .Y(mux_out4)
    );
    
    // Concatenator C1
    assign concat_mux1 = {sum1, mux_out1};  // FA1 Sum and MUX1 output

    // Concatenator C2
    assign concat_mux3 = {sum2, mux_out3};  // FA2 Sum and MUX3 output

    // Final MUX outputs
    assign mux2 = mux_out2;
    assign mux4 = mux_out4;

    
endmodule
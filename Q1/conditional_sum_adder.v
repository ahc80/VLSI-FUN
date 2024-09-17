// ECSE 318 
// Andrew Chen and Audrey Michel

module conditional_sum_adder (
    input x[8], //0-7 Inputs X
    input y[8], //0-7 Inputs Y

    output S1,
    output S2,
);

    wire sum1, cout1; //FA1 outputs
    wire sum2, cout2; //FA2 outputs
    wire sum3, cout3; //FA3 outputs

    wire mux_out1, mux_out2;  // MUX1, MUX2 outputs
    wire mux_out3, mux_out4;  // MUX3, MUX4 outputs

    //Instantiate

    //EDIT NEED TO FIX CIN
    full_adder FA1 (
        .A(x[0]),
        .B(y[0]),  
        .Cin(?),  // Cin = 1 for FA1
        .Sum(sum1),  
        .Cout(cout1)
    );

    full_adder FA2 (
        .A(x[1]),
        .B(y[1]),  
        .Cin(1'b0),  // Cin = 0 for FA1
        .Sum(sum2),  
        .Cout(cout2)
    );

    full_adder FA3 (
        .A(x[2]),
        .B(y[2]),  
        .Cin(1'b1),  // Cin = 1 for FA1
        .Sum(sum3),  
        .Cout(cout3)
    );

    // Instantiate MUX1 (controlled by FA1 Cout)
    multiplexer_1bit MUX1 (
        .A(sum3),  // Input from FA2 Sum
        .B(sum4),  // Input from FA3 Sum
        .Select(cout1),  // Cout from FA1
        .Y(mux_out1) 
    );

    assign concat_mux1 = {sum1, mux_out1};

    // Instantiate MUX2 (controlled by FA1 Cout)
    multiplexer_1bit MUX2 (
        .A(cout3),  // Input from FA2 Cout
        .B(cout4),  // Input from FA3 Cout
        .Select(cout1),  // Cout from FA1
        .Y(mux_out2)
    );
    
    //Red Box1
    ///////////////////////////////////////////

    red_box box1 (
        .x2(x[2]),
        .y2(y[2]),
        .x3(x[3]),
        .y3(x[3]),
        .concat_mux1(mux_in3_1),
        .mux2(mux4_1),
        .concat_mux3(mux_in3_2),
        .mux4(mux4_2),
    );

    ///////////////////////////////////////////

    // Instantiate MUX3 (controlled by MUX2 out)
    multiplexer_2bit MUX3 (
        .A(mux_in3_1),  // Input from Mux Concat 1
        .B(mux_in3_2),  // Input from Mux Concat 2
        .Select(mux_out2),  // Cout from MUX2
        .Y(mux_out3)
    );

    assign concat_mux2 = {mux_out3, concat_mux1};

    // Instantiate MUX4 (controlled by MUX2 out)
    multiplexer_1bit MUX4 (
        .A(mux4_1),  // Input from FA3 Cout
        .B(mux4_2),  // Input from FA4 Cout
        .Select(mux_out2),  // Cout from MUX2
        .Y(mux_out4)
    );

    ///////////////////////////////////////////
    //Red Box2

    red_box box2 (
        .x2(x[4]),
        .y2(y[4]),
        .x3(x[5]),
        .y3(x[5]),
        .concat_mux1(mux_in3_1), //
        .mux2(mux4_1),
        .concat_mux3(mux_in3_2), //
        .mux4(mux4_2),
    );    

    //Red Box3

    red_box box3 (
        .x2(x[6]),
        .y2(y[6]),
        .x3(x[7]),
        .y3(x[7]),
        .concat_mux1(mux_in3_1), //
        .mux2(mux4_1),
        .concat_mux3(mux_in3_2), //
        .mux4(mux4_2),
    );
    

    
endmodule
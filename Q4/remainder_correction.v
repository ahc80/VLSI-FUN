module remainder_correction (
    input       A,      // Connects to output sum from CAS
    input[1:0]  And_in, // IM UNSURE WHAT THIS INPUT IS SUPPOSED TO CONNECT TO
    input       C_in,

    output      C_out,   
    output      R       // Remainder bit
); 
    
    wire and_output;

    and (and_output, And_in[1], And_in[0]);

    full_adder FA (
        .A(A),
        .B(and_output),
        .Cin(C_in),
        .Sum(R),
        .Cout(C_out)
    );

endmodule
module remainder_correction (
    input       A,              // Connects to output sum from CAS
    input       Q_bit,          // Input for respective bit from divisor
    input       Anded_with_Q,    // Input anded with Q bit. Will be a "Line input"
    input       C_in,

    output      C_out,   
    output      R               // Remainder bit
);
    
    wire and_output;

    and (and_output, Q_bit, Anded_with_Q);

    full_adder FA (
        .A(A),
        .B(and_output),
        .Cin(C_in),
        .Sum(R),
        .Cout(C_out)
    );

endmodule
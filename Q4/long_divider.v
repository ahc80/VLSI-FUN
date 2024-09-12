module long_divider (

    parameter first_c_in_value = 1'b1,

    input[3:0] M,   // Divisor
    input[6:0] D,   // Dividend

    output[3:0] Q,  // Quotient
    output[3:0] R,  // Remainder
);

    4_RC_array (
        input[3:0]  A       // Corresponds to A input of full adder 
        input[3:0]  And_in   
        input       C_in

        output[3:0] R,      // Remainder
    );

    wire[3:0] cas_row1_S
    wire[3:0] cas_row2_S
    wire[3:0] cas_row3_S
    wire[3:0] cas_row4_S

    4_CAS_array 4cas0 (
        .M  (M),
        .A  (D[6:3]),
        .B  (first_c_in_value),

        .Q  (Q[3]),
        .S  (cas_row1_S)
    )

    assign cas_row1_S =                 // How to shift bits left and input D value?

    4_CAS_array 4cas1 (
        .M  (M),
        .A  (D[]),
        .B  (first_c_in_value),

        .Q  (Q[3]),
        .S  (cas_row1_S)
    )

    4_CAS_array 4cas2 (
        .M  (M),
        .A  (D[6:3]),
        .B  (first_c_in_value),

        .Q  (Q[3]),
        .S  (cas_row1_S)
    )

    4_CAS_array 4cas3 (
        .M  (M),
        .A  (D[6:3]),
        .B  (first_c_in_value),

        .Q  (Q[3]),
        .S  (cas_row1_S)
    )



    
endmodule
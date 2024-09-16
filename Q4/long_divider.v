module long_divider (

    parameter first_c_in_value  = 1'b1,
    parameter 4_RC_array_and_in = 4'b0101,
    parameter 4_RC_array_c_in   = 1'b0,

    input  [3:0] M,  // Divisor
    input  [6:0] D,  // Dividend

    output [3:0] Q,  // Quotient
    output [3:0] R,  // Remainder
);
    wire [4:0] cas_array_sum [3:0];
    wire       Q_wire        [3:0]; // Q[0] is Q0, Q[1] is Q1, so forth
    
    assign cas_array_sum[0] = D[2];
    assign cas_array_sum[1] = D[1];
    assign cas_array_sum[2] = D[0];

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin
            if(i=0) begin
            // Create uppermost 4_CAS_array
                4_CAS_array 4cas0 (
                    .M  (M),
                    .A  (D[6:3]),
                    .B  (first_c_in_value),

                    .Q  (Q_wire[3]),
                    .S  (cas_array_sum[0][4:1])
                )
            end
            else if(i>0) begin
            // Create next 3 4_CAS_arrays        
                4_CAS_array 4cas123 (
                    .M  (M[3:0]),
                    .A  (cas_array_sum[i-1]),
                    .B  (Q_wire[4-i]),

                    .Q  (Q_wire[3-i]),
                    .S  (cas_array_sum[i][4:1])
                )
            end
        end
    endgenerate

    4_RC_array (
        .A      (cas_array_sum[3][4:1]),
        .And_in (4_RC_array_and_in),
        .C_in   (4_RC_array_c_in),

        .R      (R[3:0])
    )
endmodule
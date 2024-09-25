`timescale 1ns/1ns

module long_divider (
    input  [3:0] M,  // Divisor
    input  [6:0] D,  // Dividend

    output [3:0] Q,  // Quotient
    output [3:0] R  // Remainder
);
    wire [4:0] cas_array_sum [3:0];
    wire       Q_wire        [3:0]; // Q[0] is Q0, Q[1] is Q1, so forth
    
    // Trick to concat D with previous sum outputs for next four_CAS_array input
    assign cas_array_sum[0][0] = D[2];
    assign cas_array_sum[1][0] = D[1];
    assign cas_array_sum[2][0] = D[0];


    four_CAS_array cas0 (
                    .M  (M[3:0]),
                    .A  (D[6:3]),
                    .B  (1'b1),

                    .Q  (Q_wire[3]),
                    .S  (cas_array_sum[0][4:1])
                );

    genvar i;
    generate
        for(i=1; i<4; i=i+1) begin
            // Create next 3 four_CAS_arrays        
                four_CAS_array cas123 (
                    .M  (M[3:0]),
                    .A  (cas_array_sum[i-1][3:0]),
                    .B  (Q_wire[4-i]),

                    .Q  (Q_wire[3-i]),
                    .S  (cas_array_sum[i][4:1])
                );
        end
    endgenerate

    four_RC_array rc0 (
        .A  (cas_array_sum[3][4:1]),
        .M  (M[3:0]),

        .R  (R[3:0])
    );

    assign Q[0] = Q_wire[0];
    assign Q[1] = Q_wire[1];
    assign Q[2] = Q_wire[2];
    assign Q[3] = Q_wire[3];
endmodule
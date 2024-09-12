module 4_RC_array (
    input[3:0]  A       // Corresponds to A input of full adder 
    input[3:0]  And_in   
    input       C_in

    output[3:0] R,      // Remainder
);

    wire[3:0] C_out_wire

    remainder_correction RC0 (                        // brain fart?
        .A      (A[0]),
        .And_in (And_in[0]),
        .C_in   (C_in),
        
        .C_out  (C_out_wire[0]),
        .R      (R[0])
    );

    genvar i;
    generate
        for(i=1; i<=3; i=i+1) begin
            remainder_correction RC (
                .A      (A[i]),
                .And_in (And_in[i]),
                .C_in   (C_out_wire[i-1]),
                
                .C_out  (C_out_wire[i]),
                .R      (R[i])
            );
        end
    endgenerate

endmodule
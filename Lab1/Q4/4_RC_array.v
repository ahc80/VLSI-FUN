`timescale 1ns/1ns

module four_RC_array (
    input[3:0]  A,       // Direct sum from 4_CAS_array -- MSB becomes "and_with_q LINE"
    input[3:0]  M,       // divisor

    output[3:0] R      // Remainder
);

    wire[3:0] C_out_wire;

    remainder_correction RC0 (      // Rightmost RC
        .A              (A[0]),
        .Q_bit          (M[0]),
        .Anded_with_Q   (A[3]),
        .C_in           (1'b0),     // Since we are subtracting
        
        .C_out          (C_out_wire[0]),
        .R              (R[0])
    );

    genvar i;
    generate
        for(i=1; i<4; i=i+1) begin
        // Instantiate RC's. begins with RC1 (second last to right). Starts left goes right
            remainder_correction RC (
                .A              (A[i]),
                .Q_bit          (M[i]),
                .Anded_with_Q   (A[3]),
                .C_in           (C_out_wire[i-1]),
                
                .C_out          (C_out_wire[i]),
                .R              (R[i])
            );
        end
    endgenerate

endmodule


module 4_CAS_array (
    input[3:0] M,     // Same as Diagonal from CAS. MSB is leftmost on diagram
    input[3:0] A,     // Same as A from CAS. the LSB is part of D later        
    input B, 
    input C_in,

    output Q,
    output[3:0] S
);
    
    wire[3:0] C_out_wire    // MSB determines Q value

    // Rightmust CAS on diagram
    controlled_adder_substractor cas0 (
        .A(A[0]),
        .B(B),
        .Diagonal(M[0]),
        .C_in(B),
        
        .C_out(C_out_wire[0]),
        .S(S[0])
    );         

    // Generating other CAS, from right to left on diagram
    genvar i;
    generate
        for(i=1; i<=3, i=i+1) begin
            controlled_adder_substractor cas (
                .A(A[i]),
                .B(B),
                .Diagonal(M[i]),
                .C_in(B),
                
                .C_out(C_out_wire[i-1]),
                .S(S[i])
            );                
        end
    endgenerate

    assign Q = C_out_wire[3];

endmodule
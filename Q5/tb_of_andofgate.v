module tb_of_andofgate ();
    
    reg A;
    reg B;

    wire S;

    and_of_gate aog (
        .A(A),
        .B(B),
        .S(S)
    );

    initial begin : Testing

        $display("A B | S");

        A = 1'b0;
        B = 1'b0;
        $display("%b %b | %b", A, B, S);

        #5;

        A = 1'b0;
        B = 1'b1;
        $display("%b %b | %b", A, B, S);

        #5;

        A = 1'b1;
        B = 1'b0;
        $display("%b %b | %b", A, B, S);

        #5;

        A = 1'b1;
        B = 1'b1;
        $display("%b %b | %b", A, B, S);
    end
endmodule
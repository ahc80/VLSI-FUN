`timescale 1ns/1ns

module tb_of_divider ();
    
    wire [3:0] Q; // Quotient                   // IS WIRE GOOD ?
    wire [3:0] R; // Remainder
    reg  [3:0] M; // Divisor
    reg  [6:0] D; // Dividend

    reg [3:0] expected_Q;
    reg [3:0] expected_R;

    long_divider ld (
        .M(M),
        .D(D),
        .Q(Q),
        .R(R)
    );


    initial begin : Testing
    // Begin case 7/2
    D           [6:0] = 7'b0000111;
    M           [3:0] = 4'b0010;
    expected_Q  [3:0] = 4'b0011;
    expected_R  [3:0] = 4'b0001;

    $display(
        "Begin test case 7/2: quotient: %d, remainder: %d, \n expected: %d | %d ",
        Q, R, expected_Q[3:0], expected_R[3:0]
    );
    #50;

    // Begin case 6/2
    D           [6:0] = 7'b0000110;
    M           [3:0] = 4'b0010;
    expected_Q  [3:0] = 4'b0110;
    expected_R  [3:0] = 4'b0000;

    $display(
        "Begin test case 6/2: quotient: %d, remainder: %d, \n expected: %d | %d ",
        Q, R, expected_Q[3:0], expected_R[3:0]
    );
    #50;
    
    // Begin case 9/4
    D           [6:0] = 7'b0001001;
    M           [3:0] = 4'b0010;
    expected_Q  [3:0] = 4'b0010;
    expected_R  [3:0] = 4'b0001;

    $display(
        "Begin test case 9/4: quotient: %d, remainder: %d, \n expected: %d | %d ",
        Q, R, expected_Q[3:0], expected_R[3:0]
    );
    #50;

    // Begin case 12/5
    D           [6:0] = 7'b0001100;
    M           [3:0] = 4'b0010;
    expected_Q  [3:0] = 4'b0010;
    expected_R  [3:0] = 4'b0010;

    $display(
        "Begin test case 12/5: quotient: %d, remainder: %d, \n expected: %d | %d ",
        Q, R, expected_Q[3:0], expected_R[3:0]
    );
    #50;

end

endmodule
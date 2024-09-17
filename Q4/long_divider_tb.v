// 2001 Verilog

module long_divider_tb (
    input  [3:0] Q, // Quotient
    input  [3:0] R, // Remainder
    output [3:0] M, // Divisor
    output [6:0] D  // Dividend
);

reg [6:0] dividend_list [4];
reg [3:0] divisor_list  [4];

reg [3:0] expected_Q    [4];
reg [3:0] expected_R    [4];


// Test cases are as stated below
// 0) 7/2
// 1) 6/2
// 2) 9/4
// 3) 12/5

assign dividend_list [0] = 7'd7;
assign dividend_list [1] = 7'b0000110;
assign dividend_list [2] = 7'b0001001;
assign dividend_list [3] = 7'b0001100;

assign divisor_list  [0] = 4'b0010;
assign divisor_list  [1] = 4'b0010;
assign divisor_list  [2] = 4'b0100;
assign divisor_list  [3] = 4'b0101;

assign expected_Q    [0] = 4'b0011;
assign expected_Q    [1] = 4'b0110;
assign expected_Q    [2] = 4'b0010;
assign expected_Q    [3] = 4'b0010;

assign expected_R    [0] = 4'b0001;
assign expected_R    [1] = 4'b0000;
assign expected_R    [2] = 4'b0001;
assign expected_R    [3] = 4'b0010;


initial begin : Testing
    var i;
    for(i=0; i<3; i=i+1) begin
    // Test each use case. Cases are (in order)
    // 0) 7/2
    // 1) 6/2
    // 2) 9/4
    // 3) 12/5

    assign M = divisor_list [i];
    assign D = dividend_list[i];

    $display(
        "Begin test case %d: quotient: %b, remainder: %b, \n expected: %b | %b ",
        i, Q, R, expected_Q[i], expected_R[i]
    )
    #50
    end
end
    
endmodule
module testing ();

wire[3:0] combo[3:0];

assign combo [0] [3:0] = 4'b0000;
assign combo [1] [3:0] = 4'b0001;
assign combo [2] [3:0] = 4'b0010;
assign combo [3] [3:0] = 4'b1111;

initial begin
$display("Welcome to the test sandbox! \n Combo values are %b %b %b and %b \n",
    combo[0][3:0], combo[1][3:0], combo[2][3:0], combo[3][3:0]);
end

endmodule
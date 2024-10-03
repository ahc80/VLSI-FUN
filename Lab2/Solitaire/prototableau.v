
// Test to make single col of tableau. Should effectively act as a "stack"

module protoTableau (
    input               clk,
    input       [5:0]   card_in,
    input       [2:0]   in_out_switch,        // [1:0] -> 10 is push in, 01 is pop out 
    output reg  [5:0]   value_out
);

reg [5:0] value_storage [7:0];

initial begin
    value_storage[0] = 6'b110111;
    value_storage[1] = 6'b110101;
    value_storage[2] = 6'b110100;
    value_storage[3] = 6'b110011;
    value_storage[4] = 6'b110010;
    value_storage[5] = 6'b110001;
    value_storage[6] = 6'b110000;
end

integer i;
always @( posedge clk ) begin
    for (i=0; i<7; i=i+1) begin                                // val_stor[0] is top of deck,
    // Iterate through all stored cards
        if (value_storage[i][3:0] != 4'b1111) begin
        // If value is not empty
            if(~in_out_switch[1] && in_out_switch[0])
            // Output if applicable
                value_out = value_storage[i][5:0];
                break;
        end
        else begin
        // If value is empty, input if applicable
            if(in_out_switch[1] && ~in_out_switch[0]) begin
                value_storage[i][5:0] = card_in[5:0];
                break;
            end
        end
        if (i == 6) begin
        // If IO value corrupt or if tableau is empty
            value_out = 6'bzzzzzz;
        end
    end 
end

endmodule

// Test to make single col of tableau. Should effectively act as a "stack"

module protoTableau (
    input   [2:0]   trigger,        // [2] -> activate "clk" [1:0] -> 10 is push in, 01 is pop out 
    output  [5:0]   value_out
);

reg [5:0] value_storage [7:0];

initial begin
    value_storage[0] = 6'b110111
    value_storage[1] = 6'b110101
    value_storage[2] = 6'b110100
    value_storage[3] = 6'b110011
    value_storage[4] = 6'b110010
    value_storage[5] = 6'b110001
    value_storage[6] = 6'b110000
end

always @(posedge trigger[2] ) begin
    integer i;
    for (i=0; i<7; i=i+1) begin                                // val_stor[0] is top of deck,
    
        if (value_storage[i][3:0] != 4'b1111) begin
        // If value is not empty
            if(~trigger[1] && trigger[0])
            // Output if applicable
                reg value_out = value_storage[i][5:0]              // illegal reg prob
                break;
        end
        else begin
        // If value is empty, input if applicable
            if(trigger[1] && ~trigger[0]) begin
                
            end
        end


        if (i == 6) begin
        // 
            output = 5'bzzzzz
        end
    end
end

endmodule
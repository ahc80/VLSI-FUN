module bit_ser_add_tb();
    reg clk, reset, load;
    reg [7:0] A, B;
    wire [7:0] result;    
    wire carry_out;        

    // Instantiate the Unit Under Test (UUT)
    serial_bit_adder uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .A(A),
        .B(B),
        .result(result),       
        .carry_out(carry_out)  
    );

    initial begin
        clk = 0;

        reset = 1;
        load = 0;
        #10 reset = 0;
        A = 8'b00000111; 
        B = 8'b00000011;
        load = 1; 
        #10 load = 0;
        
        #100;
        $display("************************************************");
        $display("Testing 7 + 3:");
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("Expected Result: 10");
        $display("************************************************");

        reset = 1;
        #10 reset = 0;
        A = 8'b00000110;
        B = 8'b00000100;
        load = 1;
        #10 load = 0;
        
        #100;
        $display("************************************************");
        $display("Testing 6 + 4:");
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("Expected Result: 10");
        $display("************************************************");
    end

    always #5 clk = ~clk;

endmodule

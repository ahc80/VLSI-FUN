`timescale 1ns / 1ps

module bit_ser_add_tb();
    reg A, B, clk, clr_n, set_n;
    wire [8:0] result;
    wire serial_result;

    // Instantiate the bit_serial_adder module
    bit_ser_add bit_ser_add_instance(
        .clk(clk),
        .A(A),
        .B(B),
        .clr_n(clr_n),
        .set_n(set_n),
        .result(result),
        .serial_result(serial_result)
    );
    
    // Clock generation
    always
        #5 clk = ~clk;

    initial begin
        // Initialize clock
        clk = 1'b0;
        
        // Test case 1: A = 7 and B = 3
        // A = 00000111, B = 00000011 (LSB first)
        clr_n = 1'b0;
        set_n = 1'b1;
        #15 clr_n = 1'b1;  // Release clear

        A = 1'b1; B = 1'b1; #10;
        A = 1'b1; B = 1'b1; #10;
        A = 1'b1; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;

        set_n = 1'b0;  // Start addition
        #90;  // Wait for addition to complete
        $display("************************************************");
        $display("Testing 7 + 3:");
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("************************************************");

        // Test case 2: A = 6 and B = 4
        // A = 00000110, B = 00000100 (LSB first)
        clr_n = 1'b0;
        set_n = 1'b1;
        #15 clr_n = 1'b1;

        A = 1'b0; B = 1'b0; #10;
        A = 1'b1; B = 1'b0; #10;
        A = 1'b1; B = 1'b1; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b0; #10;

        set_n = 1'b0;
        #90;
        $display("************************************************");
        $display("Testing 6 + 4:");
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("************************************************");
    end
endmodule

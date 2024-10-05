module alu_tb;

    // Testbench signals
    reg [15:0] A, B;         // 16-bit input operands
    reg [4:0] alu_code;      // 5-bit ALU control signals
    wire [15:0] C;           // 16-bit result from the ALU
    wire overflow;           // Overflow flag

    // Instantiate the ALU module
    alu uut (
        .A(A),
        .B(B),
        .alu_code(alu_code),
        .C(C),
        .overflow(overflow)
    );

    // Test procedure
    initial begin
        // Display header
        $display("==================================================================");
        $display(" A         | B         | ALU_CODE | C           | OVERFLOW");
        $display("==================================================================");

        // Test signed addition (alu_code = 00000)
	$display("======== Testing arithmetic ========");
	$display("signed addition (alu_code = 00000)");
        A = 16'h0000; B = 16'h0001; alu_code = 5'b00000; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        A = 16'h7FFF; B = 16'h0001; alu_code = 5'b00000; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // Test unsigned addition (alu_code = 00001)
	$display("unsigned addition (alu_code = 00001)");
        A = 16'hFFFE; B = 16'h0001; alu_code = 5'b00001; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        A = 16'h8000; B = 16'h8000; alu_code = 5'b00001; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // Test signed subtraction (alu_code = 00010)
	$display("signed subtraction (alu_code = 00010)");
        A = 16'h0000; B = 16'h0001; alu_code = 5'b00010; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        A = 16'h8000; B = 16'h7FFF; alu_code = 5'b00010; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // Test unsigned subtraction (alu_code = 00011)
	$display("unsigned subtraction (alu_code = 00011)");
        A = 16'hFFFF; B = 16'h0001; alu_code = 5'b00011; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        A = 16'h0001; B = 16'h0002; alu_code = 5'b00011; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // Test increment (alu_code = 00100)
	$display("increment (alu_code = 00100)");
        A = 16'hFFFE; B = 16'h0000; alu_code = 5'b00100; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // Test decrement (alu_code = 00101)
	$display("decrement (alu_code = 00101)");
        A = 16'h0001; B = 16'h0000; alu_code = 5'b00101; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

	$display("======== Testing Logic ========");
        // Test AND operation (alu_code = 01000)
        A = 16'hFFFF; B = 16'h00FF; alu_code = 5'b01000; #10;
        $display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

        // Test OR operation (alu_code = 01001)
        A = 16'hF0F0; B = 16'h0F0F; alu_code = 5'b01001; #10;
        $display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

        // Test XOR operation (alu_code = 01010)
        A = 16'hAAAA; B = 16'h5555; alu_code = 5'b01010; #10;
        $display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

        // Test NOT operation (alu_code = 01100)
        A = 16'h1234; B = 16'h0000; alu_code = 5'b01100; #10;
        $display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);
	
	$display("======== Testing Shift (CODE = 3'b000) ========");
     	$display("Testing Logical Left Shift (alu_code = 10000)");
    	A = 16'h000F; B = 16'h0002; alu_code = 5'b10000; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	A = 16'h00FF; B = 16'h0004; alu_code = 5'b10000; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	$display("Testing Logical Right Shift (alu_code = 10001)");
    	A = 16'hF000; B = 16'h0004; alu_code = 5'b10001; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	A = 16'h0FFF; B = 16'h0003; alu_code = 5'b10001; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	$display("Testing Arithmetic Left Shift (alu_code = 10010)");
    	A = 16'h000F; B = 16'h0002; alu_code = 5'b10010; #10;
   	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	A = 16'h00FF; B = 16'h0004; alu_code = 5'b10010; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

	A = 16'hf0FF; B = 16'h0004; alu_code = 5'b10010; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	$display("Testing Arithmetic Right Shift (alu_code = 10011) ");
    	A = 16'hF000; B = 16'h0004; alu_code = 5'b10011; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

    	A = 16'h8001; B = 16'h0003; alu_code = 5'b10011; #10;
    	$display("%b | %b | %b | %b | %b", A, B, alu_code, C, overflow);

        $display("======== Testing Set Condition (CODE = 3'b000) ========");
	// Test set less than (alu_code = 11000)
	$display("sle (A <= B): 000");
        A = 16'h0001; B = 16'h0002; alu_code = 5'b11000; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        A = 16'h0002; B = 16'h0001; alu_code = 5'b11000; #10;
        $display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);
	
	// Test Set Less Than (SLT, alu_code = 11001)
    	$display("slt (A < B): 001");
	A = 16'h0001; B = 16'h0002; alu_code = 5'b11001; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

    	A = 16'h0002; B = 16'h0001; alu_code = 5'b11001; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

	// Test Set Greater or Equal (SGE, alu_code = 11010)
	$display("sge (A >= B): 010");
    	A = 16'h0002; B = 16'h0002; alu_code = 5'b11010; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

    	A = 16'h0002; B = 16'h0001; alu_code = 5'b11010; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

	// Test Set Greater Than (SGT, alu_code = 11011)
	$display("sgt (A > B): 011");
    	A = 16'h0002; B = 16'h0001; alu_code = 5'b11011; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

    	A = 16'h0001; B = 16'h0002; alu_code = 5'b11011; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

	// Test Set Equal (SEQ, alu_code = 11100)
	$display("seq (A == B): 100");
    	A = 16'h0001; B = 16'h0001; alu_code = 5'b11100; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);
	
    	A = 16'h0001; B = 16'h0002; alu_code = 5'b11100; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

	// Test Set Not Equal (SNE, alu_code = 11101)
	$display("sne (A != B): 101");
    	A = 16'h0001; B = 16'h0002; alu_code = 5'b11101; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

    	A = 16'h0001; B = 16'h0001; alu_code = 5'b11101; #10;
    	$display("%h | %h | %b | %h | %b", A, B, alu_code, C, overflow);

        // End simulation
        $display("==================================================================");
        $stop;
    end
endmodule


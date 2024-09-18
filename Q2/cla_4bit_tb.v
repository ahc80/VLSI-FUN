// ECSE 318
// Andrew Chen and Audrey Michel
`timescale 1ns/1ns // ask saab about the timescale

module carry_lookahead_adder_tb;

    reg [3:0] A;         // 4-bit input A
    reg [3:0] B;         // 4-bit input B
    reg Cin;              // Carry-in input
    
    wire [3:0] S;     // Sum output
    wire Cout;            // Carry-out output
    
    carry_lookahead_adder cla_instance (
        .A(A),
        .B(B),
        .carry_in(Cin),
        .sum(S),
        .carry_out(Cout)
    );
   
    initial begin
        //Verifies the correct handling of a case where the carry propagates through all 4 bits (worst-case scenario for carry propagation)
        $display("LONGEST PROPAGATION DELAY TEST:");
        A = 4'b1111; // 15 Binary
        B = 4'b0001; // 1 Binary
        Cin = 1'b1; // 1 Binary
        // 15 + 1 + 1 = 17 Overflow
        // 600 for the longest delay possible, so it has enough time to propagate
        #600 $display("A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", A, B, Cin, S, Cout);
              $display("A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", A, B, Cin, S, Cout);
        $display;
        
        //Verifies the basic addition of two 4-bit numbers without a carry-in, ensuring the sum and carry-out are correct.
        $display("Testing Addition:");
        A = 4'b0110; // 6 Binary
        B = 4'b0101; // 5 Binary
        Cin = 1'b0; // 0 Binary
        // 5 + 6 + 0 = 11
        #100 $display("A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", A, B, Cin, S, Cout);
              $display("A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", A, B, Cin, S, Cout);
        $display;
        
        //Tests the addition of smaller values with a carry-in, verifying correct handling of the carry.
        $display("Testing Addition:");
        A = 'd4; // 4 decimal -> This is ok because it will assign to 4 bit register 'd4 == 4'b0100
        B = 'd3; // 3 decimal
        Cin = 1'b1; //1 Binary
        // 4 + 3 + 1 = 8
        #100 $display("A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", A, B, Cin, S, Cout);
              $display("A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", A, B, Cin, S, Cout);
        $display;
        
        //Verifies the correct addition of larger values with a carry-in, ensuring the sum and carry-out behave as expected near the 4-bit maximum limit.
        $display("Testing Addition:");
        A = 'd9; // 9 decimal
        B = 'd5; // 5 decimal
        Cin = 1'b1; // 1 Binary
        // 9 + 5 + 1 = 15
        #100 $display("A: %b +  B:%b   (Cin=%b) =  Sum:%b   (Cout=%b)", A, B, Cin, S, Cout);
              $display("A: %d +  B:%d   (Cin=%d) =  Sum:%d   (Cout=%d)", A, B, Cin, S, Cout);
    end

endmodule

//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2
`timescale 1ps/1fs

module adder_tb;
    reg [15:0] A, B;
    wire [15:0] C;
    reg [2:0] control;
    reg cin, coe;
    wire vout, cout;


    adder adder_instance(
        .A(A),
        .B(B),
        .control(control),
        .Carryout(coe),
        .C(C),
        .overFlag(vout),
        .coutFlag(cout)
    );

    initial begin

        $display("Testing All Adder Functionality for inputs 0000 and 0001 Below:");
        A = 16'h0000;
        B = 16'h0001;
        cin = 1'b0;
        coe = 1'b0;
        control = 3'b000;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b001;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b010;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;
        
        control = 3'b011;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b100;
        #100    $display("control: %b  A: %h + 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d + 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        control = 3'b101;
        #100    $display("control: %b  A: %h - 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d - 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        
        $display("Testing All Adder Functionality for inputs 000F and 000F cin = 1 Below:");
        A = 16'h000F;
        B = 16'h000F;
        cin = 1'b1;
        coe = 1'b0;
        control = 3'b000;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b001;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b010;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;
        
        control = 3'b011;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b100;
        #100    $display("control: %b  A: %h + 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d + 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        control = 3'b101;
        #100    $display("control: %b  A: %h - 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d - 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        
        $display("Testing All Adder Functionality for inputs 7F00 and 0300 Below:");
        A = 16'h7F00;
        B = 16'h0300;
        cin = 1'b0;
        coe = 1'b0;
        control = 3'b000;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b001;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b010;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;
        
        control = 3'b011;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b100;
        #100    $display("control: %b  A: %h + 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d + 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        control = 3'b101;
        #100    $display("control: %b  A: %h - 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d - 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        $display("Testing All Adder Functionality for inputs FF00 and 0100 cin=1 Below:");
        A = 16'hFF00;
        B = 16'h0100;
        cin = 1'b1;
        coe = 1'b0;
        control = 3'b000;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b001;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b010;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;
        
        control = 3'b011;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b100;
        #100    $display("control: %b  A: %h + 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d + 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        control = 3'b101;
        #100    $display("control: %b  A: %h - 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d - 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        
        $display("Testing All Adder Functionality for inputs 8100 and 8000 cin = 1 coe = 1 Below:");
        A = 16'h7F00;
        B = 16'h0300;
        cin = 1'b1;
        coe = 1'b1;
        control = 3'b000;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b001;
        #100    $display("control: %b coe: %b cin: %b A: %h + B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d +  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b010;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;
        
        control = 3'b011;
        #100    $display("control: %b coe: %b cin: %b A: %h - B: %h = C: %h vout: %b cout: %b", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display("control: %b  coe: %d cin %d A: %d -  B: %d = C: %d vout: %d cout: %d", control, coe, cin, $signed(A), $signed(B), $signed(C), vout, cout);
        $display;

        control = 3'b100;
        #100    $display("control: %b  A: %h + 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d + 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
        
        control = 3'b101;
        #100    $display("control: %b  A: %h - 1 =  C: %h vout: %b cout: %b", control, $signed(A), $signed(C), vout, cout);
        #100    $display("control: %d  A: %d - 1=  C: %d vout: %d cout: %d", control, $signed(A), $signed(C), vout, cout);
        $display;
    end

endmodule
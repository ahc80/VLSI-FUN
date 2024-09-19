`timescale 1ns/1ns

module tb_of_q_five ();
    
    reg X1;
    reg X2;

    wire Zstruc [2:1];
    wire Zbehav [2:1];

    verilog_Behavioral bhv (
        .X1(X1),
        .X2(X1),
        .Z1(Zbehav[1]),
        .Z2(Zbehav[2])
    );

    verilog_Structural strc (
        .X1(X1),
        .X2(X2),
        .Z1(Zstruc[1]),
        .Z2(Zstruc[2])
    );

    initial begin
        //
        // Testing procedure key:
        // X1 X2 | S1 S2 | Z1 Z2
        // 
        //  0  0 |  0  0 |  0  0
        //  0  1 |  0  0 |  0  0
        //  1  1 |  1  0 |  1  1
        //  0  1 |  1  1 |  1  0
        //  0  0 |  1  1 |  1  0
        //  1  0 |  0  1 |  0  1
        //  1  1 |  0  1 |  0  0
        //  0  1 |  0  0 |  0  0
        //

        $display("Begin testing. Key: X1 X2 | Behav: Z1 Z2 | Struct: Z1 Z2 | [Expected Z1 Z2]");

        // Begin 00 | 00 | 00
        X1 = 1'b0;
        X2 = 1'b0;

        $display("00 | Behav: %b%b | Struct: %b%b | 00", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 01 | 00 | 00
        X1 = 1'b0;
        X2 = 1'b0;

        $display("01 | Behav: %b%b | Struct: %b%b | 00", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 11 | 10 | 11
        X1 = 1'b0;
        X2 = 1'b0;

        $display("11 | Behav: %b%b | Struct: %b%b | 11", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 01 | 11 | 10
        X1 = 1'b0;
        X2 = 1'b0;

        $display("01 | Behav: %b%b | Struct: %b%b | 10", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 00 | 11 | 10
        X1 = 1'b0;
        X2 = 1'b0;

        $display("00 | Behav: %b%b | Struct: %b%b | 10", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 10 | 01 | 01
        X1 = 1'b0;
        X2 = 1'b0;

        $display("10 | Behav: %b%b | Struct: %b%b | 01", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 11 | 01 | 00
        X1 = 1'b0;
        X2 = 1'b0;

        $display("11 | Behav: %b%b | Struct: %b%b | 00", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;

        // Begin 01 | 00 | 00
        X1 = 1'b0;
        X2 = 1'b0;

        $display("01 | Behav: %b%b | Struct: %b%b | 00", Zbehav[1], Zbehav[2], Zstruc[1], Zstruc[2]);
        #50;
    end


endmodule
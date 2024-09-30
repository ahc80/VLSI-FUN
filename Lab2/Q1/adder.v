module adder(
    input [15:0] A, B, //16 bit inputs
    input [2:0] control, //3 bit control 
    input Carryout, // Carry out enable
    output [15:0] C, //16 bit output C
    output reg overFlag, coutFlag // Overflow flag and Cout Flag
);

    reg cin; // Carry-in signal, controlled based on the operation (e.g., subtraction)
    
    // Local parameters for different operations, each assigned a 3-bit opcode

    localparam add  = 3'b000; //A+B=>C    signed addition
    localparam addu = 3'b001; //A+B=>C    unsigned addition
    localparam sub  = 3'b010; //A-B=>C    signed subtraction
    localparam subu = 3'b011; //A-B=>C    unsigned subtraction
    localparam inc  = 3'b100; //A+1=>C    signed increment
    localparam dec  = 3'b101; //A-1=>C    signed decrement

    // Registers to store modified versions of A and B for operations like subtraction
    reg [15:0] Ain, Bin; 
    wire coutwire; // Wire to capture carry-out from the CLA (Carry Look-Ahead Adder)

    cla16bit cla16bit_instance(
        .A(Ain),
        .B(Bin),
        .cin(cin),
        .SUM(C),
        .C_OUT(coutwire)
    );


    always @ (*) begin //A,B,Carryout,control, coutwire, cin synthesis
        case(control)
            add: begin
                cin = 1'b0;
                Ain = A;
                Bin = B ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            addu: begin
                cin = 1'b0;
                Ain = A;
                Bin = B ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = 1'b0;
            end

            sub: begin // Assuming A and B input in two's complement form
                cin = 1'b1;
                Ain = A;
                Bin = B ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            subu: begin
                cin = 1'b1;
                Ain = A;
                Bin = B ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = 1'b0;
            end

            inc: begin
                cin = 1'b0;
                Ain = A;
                Bin = 16'h0001 ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            dec: begin
                cin = 1'b1;
                Ain = A;
                Bin = 16'h0001 ^ {16{cin}};
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            default: begin
                cin = 1'b0;
                Ain = 16'h0000;
                Bin = 16'h0000;
                overFlag = 1'b0;
                coutFlag = 1'b0;
                
            end
        endcase
    end

endmodule
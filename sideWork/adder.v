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

    //Instance
    cla16bit cla16bit_instance(
        .A(Ain),
        .B(Bin),
        .cin(cin),
        .SUM(C),
        .C_OUT(coutwire)
    );

    // Always block that selects the operation based on the control signal
    always @ (*) begin
        case (control)
            // Signed addition: A + B => C
            add: begin
                cin = 1'b0;                // Carry-in is 0 for addition
                Ain = A;                   // A remains unchanged
                Bin = B ^ {16{cin}};       // B remains unchanged (XOR with 0 does nothing)
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]); // Overflow detection for signed addition
            end

            // Unsigned addition: A + B => C
            addu: begin
                cin = 1'b0;                // Carry-in is 0 for addition
                Ain = A;                   // A remains unchanged
                Bin = B ^ {16{cin}};       // B remains unchanged
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = 1'b0;           // No overflow detection for unsigned addition
            end

            // Signed subtraction: A - B => C
            sub: begin
                cin = 1'b1;                // Carry-in is 1 for subtraction (two's complement)
                Ain = A;                   // A remains unchanged
                Bin = B ^ {16{cin}};       // Invert B for subtraction (XOR with 1 gives two's complement)
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]); // Overflow detection for signed subtraction
            end

            // Unsigned subtraction: A - B => C
            subu: begin
                cin = 1'b1;                // Carry-in is 1 for subtraction
                Ain = A;                   // A remains unchanged
                Bin = B ^ {16{cin}};       // Invert B for subtraction (two's complement)
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = 1'b0;           // No overflow detection for unsigned subtraction
            end

            // Signed increment: A + 1 => C
            inc: begin
                cin = 1'b0;                // No carry-in for increment
                Ain = A;                   // A remains unchanged
                Bin = 16'h0001 ^ {16{cin}}; // Increment by 1 (Bin = 1)
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]); // Overflow detection for increment
            end

            // Signed decrement: A - 1 => C
            dec: begin
                cin = 1'b1;                // Carry-in is 1 for decrement
                Ain = A;                   // A remains unchanged
                Bin = 16'h0001 ^ {16{cin}}; // Decrement by 1 (Bin = 1 in two's complement)
                coutFlag = (~Carryout) ? coutwire : 1'b0; // Carry-out enabled if Carryout is low
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]); // Overflow detection for decrement
            end

            // Default case: set everything to 0 if no valid control signal is provided
            default: begin
                cin = 1'b0;                // No carry-in
                Ain = 16'h0000;            // Set A and B to 0
                Bin = 16'h0000;
                overFlag = 1'b0;           // No overflow
                coutFlag = 1'b0;           // No carry-out
            end
        endcase
    end

endmodule
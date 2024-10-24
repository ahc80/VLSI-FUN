//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2
// Adder Module (1995 compliant)
module adder(
    A, B,         // 16-bit inputs
    control,      // 3-bit control input
    Carryout,     // Carry out enable
    C,            // 16-bit output
    overFlag,     // Overflow flag
    coutFlag      // Cout Flag
);

    // Declare inputs and outputs
    input [15:0] A, B;    // 16-bit inputs
    input [2:0] control;  // 3-bit control
    input Carryout;       // Carry out enable
    output [15:0] C;      // 16-bit output
    output overFlag, coutFlag; // Overflow flag, Cout flag

    wire [15:0] C;
    reg overFlag, coutFlag;
    reg cin; // Carry-in signal, controlled based on the operation (e.g., subtraction)
    
    // Local parameters for different operations
    parameter add  = 3'b000; // A + B => C (signed addition)
    parameter addu = 3'b001; // A + B => C (unsigned addition)
    parameter sub  = 3'b010; // A - B => C (signed subtraction)
    parameter subu = 3'b011; // A - B => C (unsigned subtraction)
    parameter inc  = 3'b100; // A + 1 => C (signed increment)
    parameter dec  = 3'b101; // A - 1 => C (signed decrement)

    reg [15:0] Ain, Bin; // Registers for operands
    wire coutwire; // Carry-out from the CLA

    // CLA instance
    cla16bit cla16bit_instance (
        .A(Ain),
        .B(Bin),
        .cin(cin),
        .SUM(C),
        .C_OUT(coutwire)
    );

    // Always block for selecting the operation
    always @ (A or B or control or Carryout) begin
        case (control)
            add: begin
                cin = 1'b0;
                Ain = A;
                Bin = B;
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            addu: begin
                cin = 1'b0;
                Ain = A;
                Bin = B;
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = 1'b0;
            end

            sub: begin
                cin = 1'b1;
                Ain = A;
                Bin = B ^ 16'hFFFF;
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            subu: begin
                cin = 1'b1;
                Ain = A;
                Bin = B ^ 16'hFFFF;
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = 1'b0;
            end

            inc: begin
                cin = 1'b0;
                Ain = A;
                Bin = 16'h0001;
                coutFlag = (~Carryout) ? coutwire : 1'b0;
                overFlag = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            dec: begin
                cin = 1'b1;
                Ain = A;
                Bin = 16'h0001 ^ 16'hFFFF;
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
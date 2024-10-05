//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2
//This verilog file is the combination of all of the files so that it can run in synthesis

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

    reg [15:0] C;
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

// ALU_test Module (1995 compliant)
module ALU_test(
    A, B, alu_code, coe, C, vout, cout
);

    // Declare inputs and outputs
    input [15:0] A;   // 16-bit input A (handle signed internally)
    input [15:0] B;   // 16-bit input B (handle signed internally)
    input [4:0] alu_code;    // ALU operation code
    input coe;               // Carry-Out Enable (Active Low)
    output [15:0] C;  // 16-bit output C (handle signed internally)
    output vout, cout;       // Overflow and Carry Out flags

    reg [15:0] C;  // Internal signed result (manually handled)
    reg vout, cout;

    wire [15:0] c;
    wire vout_wire, cout_wire;

    // Local parameter declarations for operations
    parameter add = 5'b00000;
    parameter addu = 5'b00001;
    parameter sub = 5'b00010;
    parameter subu = 5'b00011;
    parameter inc = 5'b00100;
    parameter dec = 5'b00101;
    parameter and_op = 5'b01000;
    parameter or_op = 5'b01001;
    parameter xor_op = 5'b01010;
    parameter not_op = 5'b01100;
    parameter sll = 5'b10000;
    parameter srl = 5'b10001;
    parameter sla = 5'b10010;
    parameter sra = 5'b10011;
    parameter sle = 5'b11000;
    parameter slt = 5'b11001;
    parameter sge = 5'b11010;
    parameter sgt = 5'b11011;
    parameter seq = 5'b11100;
    parameter sne = 5'b11101;

    // Instantiate the adder module
    adder adder_instance(
        .A(A),
        .B(B),
        .control(alu_code[2:0]),
        .Carryout(coe),
        .C(c),
        .overFlag(vout_wire),
        .coutFlag(cout_wire)
    );

    // ALU operation selection
    always @(A or B or alu_code or coe) begin
        vout = 1'b0;
        cout = 1'b0;
        
        case (1'b1)  // Explicit OR conditions inside the case block
            (alu_code == add) | (alu_code == addu) | (alu_code == sub) | (alu_code == subu) | (alu_code == inc) | (alu_code == dec): begin
                C = c;  // Use the output from the adder for all arithmetic operations
            end

            (alu_code == and_op): begin
                C = A & B;  // Bitwise AND
            end

            (alu_code == or_op): begin
                C = A | B;  // Bitwise OR
            end

            (alu_code == xor_op): begin
                C = A ^ B;  // Bitwise XOR
            end

            (alu_code == not_op): begin
                C = ~A;  // Bitwise NOT
            end

            (alu_code == sll): begin
                C = A << B[3:0];  // Logical left shift
            end

            (alu_code == srl): begin
                C = A >> B[3:0];  // Logical right shift
            end

            (alu_code == sla): begin
                case (B[3:0])
                    4'b0001: C = {A[15], A[14:0], 1'b0};  // Arithmetic left shift by 1
                    4'b0010: C = {A[15], A[13:0], 2'b00}; // Arithmetic left shift by 2
                    4'b0011: C = {A[15], A[12:0], 3'b000}; // Arithmetic left shift by 3
                    4'b0100: C = {A[15], A[11:0], 4'b0000}; // Arithmetic left shift by 4
                    default: C = {A[15], A[14:0], 1'b0};  // Default case (shift by 1)
                endcase
            end

            (alu_code == sra): begin
                case (B[3:0])
                    4'b0001: C = {A[15], A[15], A[14:1]};  // Arithmetic right shift by 1
                    4'b0010: C = {A[15], A[15], A[15], A[13:2]}; // Arithmetic right shift by 2
                    4'b0011: C = {A[15], A[15], A[15], A[15], A[12:3]}; // Arithmetic right shift by 3
                    4'b0100: C = {A[15], A[15], A[15], A[15], A[15], A[11:4]}; // Arithmetic right shift by 4
                    default: C = {A[15], A[15], A[14:1]};  // Default case (shift by 1)
                endcase
            end

            (alu_code == sle): begin
                C = (A <= B) ? 16'h0001 : 16'h0000;  // Set if less than or equal
            end

            (alu_code == slt): begin
                C = (A < B) ? 16'h0001 : 16'h0000;  // Set if less than
            end

            (alu_code == sge): begin
                C = (A >= B) ? 16'h0001 : 16'h0000;  // Set if greater than or equal
            end

            (alu_code == sgt): begin
                C = (A > B) ? 16'h0001 : 16'h0000;  // Set if greater than
            end

            (alu_code == seq): begin
                C = (A == B) ? 16'h0001 : 16'h0000;  // Set if equal
            end

            (alu_code == sne): begin
                C = (A != B) ? 16'h0001 : 16'h0000;  // Set if not equal
            end

            default: begin
                C = 16'h0000;  // Default output
            end
        endcase

        // Update overflow and carry-out flags if using the adder operations
        if (alu_code[4:3] == 2'b00) begin
            vout = vout_wire;  // Overflow signal
            cout = cout_wire;  // Carry-out signal
        end
    end
endmodule

module cla16bit (
    A, B, cin, SUM, C_OUT
);

    // Declare inputs and outputs
    input [15:0] A;      // 16-bit input A
    input [15:0] B;      // 16-bit input B
    input cin;           // Carry-in signal
    output [15:0] SUM;   // 16-bit sum output
    output C_OUT;        // Carry-out signal

    wire [15:0] SUM;
    wire C_OUT;

    wire [15:0] G, P;    // Generate and propagate signals
    wire [16:0] C;       // Carry signals

    assign C[0] = cin;   // Initial carry-in

    // Generate and propagate logic for each bit
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign C[1] = G[0] | (P[0] & C[0]);

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign C[2] = G[1] | (P[1] & C[1]);

    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign C[3] = G[2] | (P[2] & C[2]);

    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign C[4] = G[3] | (P[3] & C[3]);

    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];
    assign C[5] = G[4] | (P[4] & C[4]);

    assign G[5] = A[5] & B[5];
    assign P[5] = A[5] | B[5];
    assign C[6] = G[5] | (P[5] & C[5]);

    assign G[6] = A[6] & B[6];
    assign P[6] = A[6] | B[6];
    assign C[7] = G[6] | (P[6] & C[6]);

    assign G[7] = A[7] & B[7];
    assign P[7] = A[7] | B[7];
    assign C[8] = G[7] | (P[7] & C[7]);

    assign G[8] = A[8] & B[8];
    assign P[8] = A[8] | B[8];
    assign C[9] = G[8] | (P[8] & C[8]);

    assign G[9] = A[9] & B[9];
    assign P[9] = A[9] | B[9];
    assign C[10] = G[9] | (P[9] & C[9]);

    assign G[10] = A[10] & B[10];
    assign P[10] = A[10] | B[10];
    assign C[11] = G[10] | (P[10] & C[10]);

    assign G[11] = A[11] & B[11];
    assign P[11] = A[11] | B[11];
    assign C[12] = G[11] | (P[11] & C[11]);

    assign G[12] = A[12] & B[12];
    assign P[12] = A[12] | B[12];
    assign C[13] = G[12] | (P[12] & C[12]);

    assign G[13] = A[13] & B[13];
    assign P[13] = A[13] | B[13];
    assign C[14] = G[13] | (P[13] & C[13]);

    assign G[14] = A[14] & B[14];
    assign P[14] = A[14] | B[14];
    assign C[15] = G[14] | (P[14] & C[14]);

    assign G[15] = A[15] & B[15];
    assign P[15] = A[15] | B[15];
    assign C[16] = G[15] | (P[15] & C[15]);

    // Sum calculation for each bit
    assign SUM[0] = A[0] ^ B[0] ^ C[0];
    assign SUM[1] = A[1] ^ B[1] ^ C[1];
    assign SUM[2] = A[2] ^ B[2] ^ C[2];
    assign SUM[3] = A[3] ^ B[3] ^ C[3];
    assign SUM[4] = A[4] ^ B[4] ^ C[4];
    assign SUM[5] = A[5] ^ B[5] ^ C[5];
    assign SUM[6] = A[6] ^ B[6] ^ C[6];
    assign SUM[7] = A[7] ^ B[7] ^ C[7];
    assign SUM[8] = A[8] ^ B[8] ^ C[8];
    assign SUM[9] = A[9] ^ B[9] ^ C[9];
    assign SUM[10] = A[10] ^ B[10] ^ C[10];
    assign SUM[11] = A[11] ^ B[11] ^ C[11];
    assign SUM[12] = A[12] ^ B[12] ^ C[12];
    assign SUM[13] = A[13] ^ B[13] ^ C[13];
    assign SUM[14] = A[14] ^ B[14] ^ C[14];
    assign SUM[15] = A[15] ^ B[15] ^ C[15];

    // Final carry-out
    assign C_OUT = C[16];

endmodule

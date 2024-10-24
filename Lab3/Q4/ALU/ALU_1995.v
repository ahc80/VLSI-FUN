//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2
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
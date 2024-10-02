module ALU(
    input signed [15:0] A,             // First operand (signed 16-bit)
    input signed [15:0] B,             // Second operand (signed 16-bit)
    input [4:0] alu_code,              // ALU operation code
    input coe,                         // Carry-Out Enable (Active Low)
    output reg signed [15:0] C,        // Result of the ALU operation (signed 16-bit)
    output reg vout, cout              // Overflow and Carry Out flags
);
    wire [15:0] c;                     // Output of the 16-bit Adder Module
    wire vout_wire;                    // Intermediate wire for overflow
    wire cout_wire;                    // Intermediate wire for carry out

    // Arithmetic Operations
    localparam add= 5'b00_000;         // A + B => C (signed addition)
    localparam addu=5'b00_001;         // A + B => C (unsigned addition)
    localparam sub= 5'b00_010;         // A - B => C (signed subtraction)
    localparam subu=5'b00_011;         // A - B => C (unsigned subtraction)
    localparam inc= 5'b00_100;         // A + 1 => C (signed increment)
    localparam dec= 5'b00_101;         // A - 1 => C (signed decrement)

    // Logic Operations
    localparam and_opp= 5'b01_000;     // A AND B
    localparam or_opp=  5'b01_001;     // A OR B
    localparam xor_opp= 5'b01_010;     // A XOR B
    localparam not_opp= 5'b01_100;     // NOT A

    // Shift Operations
    localparam sll= 5'b10_000;         // Logical left shift A by the amount of B[3:0]
    localparam srl= 5'b10_001;         // Logical right shift A by the amount of B[3:0]
    localparam sla= 5'b10_010;         // Arithmetic left shift A by the amount of B[3:0]
    localparam sra= 5'b10_011;         // Arithmetic right shift A by the amount of B[3:0]

    // Set Condition Operations
    localparam sle= 5'b11_000;         // If A <= B then C = <0...0001>
    localparam slt= 5'b11_001;         // If A < B then C = <0...0001>
    localparam sge= 5'b11_010;         // If A >= B then C = <0...0001>
    localparam sgt= 5'b11_011;         // If A > B then C = <0...0001>
    localparam seq= 5'b11_100;         // If A = B then C = <0...0001>
    localparam sne= 5'b11_101;         // If A != B then C = <0...0001>

    // Instantiate the adder module
    adder adder_instance(
        .A(A),                          // First operand
        .B(B),                          // Second operand
        .CODE(alu_code[2:0]),          // ALU operation code for the adder
        .coe(coe),                     // Carry-out enable signal (Active Low)
        .C(c),                          // Result of the addition/subtraction
        .vout(vout_wire),              // Overflow signal from the adder
        .cout(cout_wire)               // Carry-out signal from the adder
    );

    // ALU operation selection based on alu_code
    always @(*) // ALU operation block triggered by changes in alu_code, A, or B
    begin: ALU
        case(alu_code)
            // Arithmetic operations
            add, addu, sub, subu, inc, dec: begin
                C = c;                 // Output from the adder
                vout = vout_wire;     // Overflow signal
                cout = cout_wire;     // Carry-out signal
            end

            // Logic operations
            and_opp: begin
                C = A & B;             // Bitwise AND
                vout = 1'b0;          // No overflow for logical operations
                cout = 1'b0;          // No carry-out for logical operations
            end
            or_opp: begin
                C = A | B;             // Bitwise OR
                vout = 1'b0;
                cout = 1'b0;
            end
            xor_opp: begin
                C = A ^ B;             // Bitwise XOR
                vout = 1'b0;
                cout = 1'b0;
            end
            not_opp: begin
                C = ~A;                // Bitwise NOT
                vout = 1'b0;
                cout = 1'b0;
            end

            // Shift operations
            sll: begin
                C = A << B[3:0];       // Logical left shift
                vout = 1'b0;
                cout = 1'b0;
            end
            srl: begin
                C = A >> B[3:0];       // Logical right shift
                vout = 1'b0;
                cout = 1'b0;
            end
            sla: begin
                C = A <<< B[3:0];      // Arithmetic left shift
                vout = 1'b0;
                cout = 1'b0;
            end
            sra: begin
                C = A >>> B[3:0];      // Arithmetic right shift
                vout = 1'b0;
                cout = 1'b0;
            end

            // Set condition operations
            sle: begin
                C = (A <= B) ? 16'h0001 : 16'h0000; // Set if less than or equal
                vout = 1'b0;
                cout = 1'b0;
            end
            slt: begin
                C = (A < B) ? 16'h0001 : 16'h0000;  // Set if less than
                vout = 1'b0;
                cout = 1'b0;
            end
            sge: begin
                C = (A >= B) ? 16'h0001 : 16'h0000; // Set if greater than or equal
                vout = 1'b0;
                cout = 1'b0;
            end
            sgt: begin
                C = (A > B) ? 16'h0001 : 16'h0000;  // Set if greater than
                vout = 1'b0;
                cout = 1'b0;
            end
            seq: begin
                C = (A == B) ? 16'h0001 : 16'h0000; // Set if equal
                vout = 1'b0;
                cout = 1'b0;
            end
            sne: begin
                C = (A != B) ? 16'h0001 : 16'h0000; // Set if not equal
                vout = 1'b0;
                cout = 1'b0;
            end

            // Default case
            default: begin
                C = 16'h0000;            // Default output
                vout = 1'b0;
                cout = 1'b0;
            end
        endcase
    end
endmodule

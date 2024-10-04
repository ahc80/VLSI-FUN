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

// The basic idea was taken from the previous homework assignment

module cla16bit (
    input [15:0] A,      // 16-bit input A
    input [15:0] B,      // 16-bit input B
    input cin,           // Carry-in signal
    output [15:0] SUM,   // 16-bit sum output
    output C_OUT         // Carry-out signal
);

    // Internal wires for the generate (G) and propagate (P) signals
    wire [15:0] G;       // Generate signal: G[i] = A[i] & B[i]
    wire [15:0] P;       // Propagate signal: P[i] = A[i] | B[i]

    // Internal wire for the carry-in signals at each bit position
    wire [16:0] C;       // Carry signals: C[i] is the carry-in for bit i, C[0] is the initial carry-in (cin)

    // Generate and propagate logic for each bit (i)
    generate
        genvar i;        // Genvar is used to generate multiple instances of the loop for each bit
        for (i = 0; i < 16; i = i + 1) begin
            assign G[i] = A[i] & B[i];   // Generate: a carry is generated if both A and B are 1 at the same bit position
            assign P[i] = A[i] | B[i];   // Propagate: a carry is propagated if either A or B is 1 at the same bit position
        end
    endgenerate

    // Carry-in signals calculation for each bit
    // The carry-in for bit i+1 depends on the generate/propagate of the current bit and the carry-in of the previous bit
    assign C[0] = cin;   // The initial carry-in for the 0th bit is the input carry-in (cin)
    
    generate
        for (i = 0; i < 16; i = i + 1) begin
            // Carry-in for the next bit: C[i+1] is generated if G[i] is 1 or if P[i] is 1 and the current carry-in (C[i]) is 1
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation for each bit
    // SUM[i] = A[i] XOR B[i] XOR carry-in (C[i])
    assign SUM[0] = A[0] ^ B[0] ^ C[0];   // Special case for the 0th bit
    generate
        for (i = 0; i < 15; i = i + 1) begin
            assign SUM[i+1] = A[i+1] ^ B[i+1] ^ C[i+1];   // Sum for the remaining bits
        end
    endgenerate

    // The final carry-out (C[16]) is the carry-out from the last bit addition
    assign C_OUT = C[16];   // The carry-out from the 16th bit is the final carry-out (C_OUT)

endmodule

module ALU_test(
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
    localparam add = 5'b00_000;         // A + B => C (signed addition)
    localparam addu = 5'b00_001;        // A + B => C (unsigned addition)
    localparam sub = 5'b00_010;         // A - B => C (signed subtraction)
    localparam subu = 5'b00_011;        // A - B => C (unsigned subtraction)
    localparam inc = 5'b00_100;         // A + 1 => C (signed increment)
    localparam dec = 5'b00_101;         // A - 1 => C (signed decrement)

    // Logic Operations
    localparam and_op = 5'b01_000;     // A AND B
    localparam or_op =  5'b01_001;     // A OR B
    localparam xor_op = 5'b01_010;     // A XOR B
    localparam not_op = 5'b01_100;     // NOT A

    // Shift Operations
    localparam sll = 5'b10_000;         // Logical left shift A by the amount of B[3:0]
    localparam srl = 5'b10_001;         // Logical right shift A by the amount of B[3:0]
    localparam sla = 5'b10_010;         // Arithmetic left shift A by the amount of B[3:0]
    localparam sra = 5'b10_011;         // Arithmetic right shift A by the amount of B[3:0]

    // Set Condition Operations
    localparam sle = 5'b11_000;         // If A <= B then C = <0...0001>
    localparam slt = 5'b11_001;         // If A < B then C = <0...0001>
    localparam sge = 5'b11_010;         // If A >= B then C = <0...0001>
    localparam sgt = 5'b11_011;         // If A > B then C = <0...0001>
    localparam seq = 5'b11_100;         // If A = B then C = <0...0001>
    localparam sne = 5'b11_101;         // If A != B then C = <0...0001>

    // Instantiate the adder module
    adder adder_instance(
        .A(A),                          // First operand
        .B(B),                          // Second operand
        .control(alu_code[2:0]),       // ALU operation code for the adder
        .Carryout(coe),                 // Carry-out enable signal (Active Low)
        .C(c),                          // Result of the addition/subtraction
        .overFlag(vout_wire),           // Overflow signal from the adder
        .coutFlag(cout_wire)            // Carry-out signal from the adder
    );

    // ALU operation selection based on alu_code
    always @(*) // ALU operation block triggered by changes in alu_code, A, or B
    begin: ALU_test
        // Initialize outputs
        vout = 1'b0;              
        cout = 1'b0;              
        
        case (alu_code)
            // Arithmetic operations
            add, addu, sub, subu, inc, dec: begin
                C = c;                 // Output from the adder
            end

            // Logic operations
            and_op: C = A & B;         // Bitwise AND
            or_op:  C = A | B;         // Bitwise OR
            xor_op: C = A ^ B;         // Bitwise XOR
            not_op: C = ~A;            // Bitwise NOT

            // Shift operations
            sll: C = A << B[3:0];      // Logical left shift
            srl: C = A >> B[3:0];      // Logical right shift
            sla: C = A <<< B[3:0];     // Arithmetic left shift
            sra: C = A >>> B[3:0];     // Arithmetic right shift

            // Set condition operations
            sle: C = (A <= B) ? 16'h0001 : 16'h0000; // Set if less than or equal
            slt: C = (A < B) ? 16'h0001 : 16'h0000;  // Set if less than
            sge: C = (A >= B) ? 16'h0001 : 16'h0000; // Set if greater than or equal
            sgt: C = (A > B) ? 16'h0001 : 16'h0000;  // Set if greater than
            seq: C = (A == B) ? 16'h0001 : 16'h0000; // Set if equal
            sne: C = (A != B) ? 16'h0001 : 16'h0000; // Set if not equal

            // Default case
            default: C = 16'h0000;            // Default output
        endcase

        // Update overflow and carry-out flags if using the adder operations
        if (alu_code[4:3] == 2'b00) begin
            vout = vout_wire;     // Overflow signal
            cout = cout_wire;     // Carry-out signal
        end
    end
endmodule

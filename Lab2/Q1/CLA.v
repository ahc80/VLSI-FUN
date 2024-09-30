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

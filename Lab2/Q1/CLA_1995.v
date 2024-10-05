//ECSE 318 Andrew Chen and Audrey Michel
//Lab 2

module cla16bit (
    A, B, cin, SUM, C_OUT
);

    // Declare inputs and outputs
    input [15:0] A;      // 16-bit input A
    input [15:0] B;      // 16-bit input B
    input cin;           // Carry-in signal
    output [15:0] SUM;   // 16-bit sum output
    output C_OUT;        // Carry-out signal

    //wire [15:0] SUM;
    //wire C_OUT;

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

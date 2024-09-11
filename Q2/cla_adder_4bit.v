`timescale 1ns/1ns

module cla_adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] Sum //(4bit + Final Carryout)
);

    wire [3:0] prop, gate; //Propagate and Generate signals
    wire [3:0] Cout; // Carry Signal
    wire [3:0] AB_sum; //Sum of A and B

    //Propagate and Generate Logic for each bit
    assign AB_sum = A ^ B // A XOR B
    assign p = AB_sum; //Propagate the A XOR B
    assign A & B; //Generate

    // Sum logic for each bit
    assign S[0] = AB_sum[0] ^ Ci;   //AB XOR Carry in
    assign S[1] = AB_sum[1] ^ Cout[0]; //AB XOR Carry 1st bit 
    assign S[2] = AB_sum[2] ^ Cout[1]; //AB XOR Carry 2nd bit
    assign S[3] = AB_sum[3] ^ Cout[2]; //AB XOR Carry 3rd bit

    //Instatiate CLA modules
    cla0 u_cla0 (

    );

    cla1 u_cla2 (
        
    );

    cla3 u_cla3 (
        
    );
    
    cla4 u_cla4 (
        
    )

    //Final Cout bit [4] 
    assign S[4] = C[3];

    
endmodule
module memory (
    input             reading, // 1 = read (output a value), 0 = write (write to reg)
    input             clk,
    input      [11:0] address,
    input      [31:0] data_in,
    output reg [31:0] data_out
);
    
    localparam NOP_op = 4'd0;
    localparam  LD_op = 4'd1;
    localparam STR_op = 4'd2;
    localparam BRA_op = 4'd3;
    localparam XOR_op = 4'd4;
    localparam ADD_op = 4'd5;
    localparam ROT_op = 4'd6;
    localparam SHF_op = 4'd7;
    localparam HLT_op = 4'd8;
    localparam CMP_op = 4'd9;

    localparam  A_cc = 3'd0;
    localparam  P_cc = 3'd1;
    localparam  E_cc = 3'd2;
    localparam  C_cc = 3'd3;
    localparam  N_cc = 3'd4;
    localparam  Z_cc = 3'd5;
    localparam NC_cc = 3'd6;
    localparam PO_cc = 3'd7;

    reg [31:0] memory [4095:0];

    integer i;
    initial begin
        for(i=0; i<4096; i=i+1) begin
            memory[i] = 32'd0;
        end
        data_out = 32'd0;

        // Q4
        
        /*
        memory[1] = { LD_op, 4'b1000, 12'd6, 12'd0};
        memory[2] = {CMP_op, 4'b0000, 12'd0, 12'd1};
        memory[3] = {HLT_op, 4'b0000, 12'd0, 12'd0};
        */

        // Q5

        /*
        memory[1]  = { LD_op, 4'b1000,  12'd1, 12'd0};
        memory[2]  = { LD_op, 4'b1000,  12'd2, 12'd1};
        memory[3]  = { LD_op, 4'b1000,  12'd3, 12'd2};
        memory[4]  = { LD_op, 4'b1000,  12'd4, 12'd3};
        memory[5]  = { LD_op, 4'b1000,  12'd5, 12'd4};
        memory[6]  = { LD_op, 4'b1000,  12'd6, 12'd5};
        memory[7]  = { LD_op, 4'b1000,  12'd7, 12'd6};
        memory[8]  = { LD_op, 4'b1000,  12'd8, 12'd7};
        memory[9]  = { LD_op, 4'b1000,  12'd9, 12'd8};
        memory[10] = { LD_op, 4'b1000, 12'd10, 12'd9};
        memory[11] = { LD_op, 4'b1000, 12'd11, 12'd10};
        memory[12] = { LD_op, 4'b1000, 12'd12, 12'd11};

        // 1
        memory[13] = { LD_op, 4'b0000, 12'd0,  12'd12};
        memory[14] = { LD_op, 4'b0000, 12'd11, 12'd0};
        memory[15] = { LD_op, 4'b0000, 12'd12, 12'd11};

        // 2
        memory[16] = { LD_op, 4'b0000, 12'd1,  12'd12};
        memory[17] = { LD_op, 4'b0000, 12'd10, 12'd1};
        memory[18] = { LD_op, 4'b0000, 12'd12, 12'd10};

        // 3
        memory[19] = { LD_op, 4'b0000, 12'd2,  12'd12};
        memory[20] = { LD_op, 4'b0000, 12'd9,  12'd2};
        memory[21] = { LD_op, 4'b0000, 12'd12, 12'd9};

        // 4
        memory[22] = { LD_op, 4'b0000, 12'd3,  12'd12};
        memory[23] = { LD_op, 4'b0000, 12'd8,  12'd3};
        memory[24] = { LD_op, 4'b0000, 12'd12, 12'd8};
        
        // 5
        memory[25] = { LD_op, 4'b0000, 12'd4,  12'd12};
        memory[26] = { LD_op, 4'b0000, 12'd7,  12'd4};
        memory[27] = { LD_op, 4'b0000, 12'd12, 12'd7};

        // 6
        memory[28] = { LD_op, 4'b0000, 12'd5,  12'd12};
        memory[29] = { LD_op, 4'b0000, 12'd6,  12'd5};
        memory[30] = { LD_op, 4'b0000, 12'd12, 12'd6};

        memory[31] = { LD_op, 4'b1000, 12'd0,  12'd12};
        memory[32] = {HLT_op, 4'b0000, 12'd0,  12'd0};
        */

        // Q6
        
        //
        memory[1]  = { LD_op, 4'b1000,  12'd4, 12'd0};  // left is A
        memory[2]  = { LD_op, 4'b1000,  12'd3, 12'd1};  // left is B
        memory[3]  = { LD_op, 4'b1000,  12'd0, 12'd2};  // C = 0
        memory[4]  = { LD_op, 4'b0000,  12'd0, 12'd3};  // Store A counter at 3
        memory[5]  = { LD_op, 4'b1000,  12'd2, 12'd4};  // Store 2 at 4
        memory[6]  = {ADD_op, 4'b0000,  12'd1, 12'd4};  // @4 = B + 2
        memory[7]  = {ADD_op, 4'b1000,  12'd4095, 12'd3}; //  A = A-1 (@3)  >> To fix bug 

        memory[8]  = { LD_op, 4'b0000,  12'd3, 12'd3};  // Check @3 = 0
        memory[9]  = {BRA_op, 4'b0000,  12'd5, 12'd14}; // End if A=0 (@3)
        memory[10]  = {ADD_op, 4'b1000,  12'd4095, 12'd3}; //  A = A-1 (@3) 
        memory[11] = {ADD_op, 4'b0000,  12'd4, 12'd2};  // C=C+@4
        memory[12] = { LD_op, 4'b0000,  12'd3, 12'd3};  // Check @3
        memory[13] = {BRA_op, 4'b0000,  12'd7, 12'd10};  // If @3 is positive, loop  CHANGED DEST

        memory[14] = { LD_op, 4'b1000,  12'd0, 12'd3};  // @3 = 0
        memory[15] = { LD_op, 4'b1000,  12'd0, 12'd4};  // @4 = 0
        memory[16] = {HLT_op, 4'b0000,  12'd0, 12'd0};  // HALT
        //
    end

    always @(posedge clk) begin
        if(reading) begin
            #1 data_out <= memory[address];    // needs a delay
        end else begin
            #1 memory[address] <= data_in;     // needs a delay
        end
    end

    /*
    || Assembly code for processor ||

    Q4
    LD  0,"6"
    CMP 1, 0
    HLT

    Q5
    LD   0,  "1"
    LD   1,  "2"
    LD   2,  "3"
    LD   3,  "4"
    LD   4,  "5"
    LD   5,  "6"
    LD   6,  "7"
    LD   7,  "8"
    LD   8,  "9"
    LD   9, "10"
    LD  10, "11"
    LD  11, "12"

    LD   0,  12
    LD  11,   0
    LD  12,  11
    
    LD   1,  12
    LD  10,   1
    LD  12,  10

    LD   2,  12
    LD   9,   2
    LD  12,   9

    LD   3,  12
    LD   8,   3
    LD  12,   8

    LD   4,  12
    LD   7,   4
    LD  12,   7

    LD   5,  12
    LD   6,   5
    LD  12,   6

    LD  12,  "0"
    HLT


    Q6

    LD   0,  "A" 
    LD   1,  "B"
    LD   2,  "2" (C)
 // ADD  2,  "2" (done above)
    LD   0,   0
    BRA 11,   5
    ADD  A, "-1"
    ADD  B,   B  No, C=C+B
    LD   A,   A
    BRA  5,   7
    HLT
    */
endmodule
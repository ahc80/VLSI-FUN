module processor (
    input         clk,
    input  [31:0] instructions,

    input  [31:0] data_in,

    output [11:0] address,
    output [31:0] data_out
);

    // ----- ----- Internal registers ----- ----- \\

    // IR  - [31:28 - OPcode][27:24 - CC][27:26 - src,dest src reg&mem/imm][23:12 - srcsAddrs/shiftOrRotate][11:0 - dest]
    reg [31:0]  IR;
    
    // PSR - [4 - Zero][3 - Negative][2 - Even][1 - Parity][0 - Carry]
    reg [ 4:0]  PSR; 

    // ----- ----- Local Parameters ----- ----- \\

    // Conidition Code
    localparam  A_cc = 3'd0;
    localparam  P_cc = 3'd1;
    localparam  E_cc = 3'd2;
    localparam  C_cc = 3'd3;
    localparam  N_cc = 3'd4;
    localparam  Z_cc = 3'd5;
    localparam NC_cc = 3'd6;
    localparam NO_cc = 3'd7;

    // Op Code
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

    // ----- ----- Processor Tasks ----- ----- \\

    // Helper tasks

    task write_reg (
        input [11:0] source, // this is part of the IR
        input [31:0] data    // fair enough but this is one line of code
    );

    endtask

    task read;

    endtask

    // Operations

    task nooperation;

    endtask

    task load;

    endtask

    task store;

    endtask

    task branch;

    endtask

    task xortask;

    endtask

    task add;

    endtask

    task rotate;

    endtask

    task shift;

    endtask

    task halt;

    endtask

    task complement;

    endtask

    
endmodule
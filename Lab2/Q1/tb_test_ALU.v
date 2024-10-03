`timescale 1ps/1fs

module alu_test_tb;
    reg [15:0] A, B;
    reg [4:0] CODE;
    reg coe;
    wire vout, cout;
    wire [15:0] C;

    reg [4:0] operation_list [0:19];
    reg [7:0] operation_names[0:19]; // Added this line to store operation names
    integer i;

    localparam add= 5'b00_000;
    localparam addu=5'b00_001;
    localparam sub= 5'b00_010;
    localparam subu=5'b00_011;
    localparam inc= 5'b00_100;
    localparam dec= 5'b00_101;

    localparam and_opp= 5'b01_000;
    localparam or_opp=  5'b01_001;
    localparam xor_opp= 5'b01_010;
    localparam not_opp= 5'b01_100;

    localparam sll= 5'b10_000;
    localparam srl= 5'b10_001;
    localparam sla= 5'b10_010;
    localparam sra= 5'b10_011;

    localparam sle= 5'b11_000;
    localparam slt= 5'b11_001;
    localparam sge= 5'b11_010;
    localparam sgt= 5'b11_011;
    localparam seq= 5'b11_100;
    localparam sne= 5'b11_101;

    ALU alu_instance(
        .A(A),
        .B(B),
        .alu_code(CODE),
        .coe(coe),
        .C(C),
        .vout(vout),
        .cout(cout)
    );

    initial begin
        // Fill operation list with control signals and names
        operation_list[0]  = add;     operation_names[0] = "add";
        operation_list[1]  = addu;    operation_names[1] = "addu";
        operation_list[2]  = sub;     operation_names[2] = "sub";
        operation_list[3]  = subu;    operation_names[3] = "subu";
        operation_list[4]  = inc;     operation_names[4] = "inc";
        operation_list[5]  = dec;     operation_names[5] = "dec";
        operation_list[6]  = and_opp; operation_names[6] = "and";
        operation_list[7]  = or_opp;  operation_names[7] = "or";
        operation_list[8]  = xor_opp; operation_names[8] = "xor";
        operation_list[9]  = not_opp; operation_names[9] = "not";
        operation_list[10] = sll;     operation_names[10] = "sll";
        operation_list[11] = srl;     operation_names[11] = "srl";
        operation_list[12] = sla;     operation_names[12] = "sla";
        operation_list[13] = sra;     operation_names[13] = "sra";
        operation_list[14] = sle;     operation_names[14] = "sle";
        operation_list[15] = slt;     operation_names[15] = "slt";
        operation_list[16] = sge;     operation_names[16] = "sge";
        operation_list[17] = sgt;     operation_names[17] = "sgt";
        operation_list[18] = seq;     operation_names[18] = "seq";
        operation_list[19] = sne;     operation_names[19] = "sne";

        // Loop through the operations and display the results
        for (i = 0; i < 20; i = i + 1) begin
            // Set test inputs
            A = 16'hA00A;
            B = 16'h1004;
            coe = 1'b0; // Carry-out enable is active low
            
            // Print operation header
            $display("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
            $display("┃                    ⟶ Testing operation: %s (CODE=%b) ⟵                                                          ┃", operation_names[i], operation_list[i]);
            $display("┃   >> Operand A: %h (hex)                                                                                         ┃", A);
            $display("┃   >> Operand B: %h (hex)                                                                                         ┃", B);
            $display("┃   >> Carry-out Enable (Low active): %b                                                                           ┃", coe);
            CODE = operation_list[i]; // Set ALU operation code

            // Simulate and delay
            #100;

            // Print results after operation
            $display("┃-------------------------------------------------------------------------------------------------------------------------------------------------┃");
            $display("┃ RESULT (HEX)    :    OUTPUT C: %h                  vout: %b                cout: %b                                                             ┃", C, vout, cout);
            $display("┃ RESULT (BINARY) :    OUTPUT C: %b                  vout: %b                cout: %b                                                             ┃", C, vout, cout);
            $display("┃ RESULT (DECIMAL):    OUTPUT C: %d                  vout: %b                cout: %b                                                             ┃", C, vout, cout);
            $display("┃-------------------------------------------------------------------------------------------------------------------------------------------------┃");
            $display("┃ INPUTS (HEX)    : A: %h    B: %h   CarryOutEn_L: %b                                                              ┃", A, B, coe);
            $display("┃ INPUTS (BINARY) : A: %b    B: %b   CarryOutEn_L: %b                                                              ┃", A, B, coe);
            $display("┃ INPUTS (SIGNED) : A: %d    B: %d   CarryOutEn_L: %b                                                              ┃", $signed(A), $signed(B), coe);
            $display("┃ INPUTS (UNSIGNED): A: %d   B: %d   CarryOutEn_L: %b                                                              ┃", A, B, coe);
            $display("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
        end
    end
endmodule

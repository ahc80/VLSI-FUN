`timescale 1ps/1fs

module alu_testbench;
    reg [15:0] operand_A, operand_B;
    reg [4:0] operation_code;
    reg carry_out_enable;
    wire overflow, carry_out;
    wire [15:0] result;

    reg [4:0] op_list [0:19];
    reg [7:0] op_names[0:19];
    integer index;

    // ALU Operation Codes
    localparam add= 5'b00_000;
    localparam addu=5'b00_001;
    localparam sub= 5'b00_010;
    localparam subu=5'b00_011;
    localparam inc= 5'b00_100;
    localparam dec= 5'b00_101;

    localparam and_op= 5'b01_000;
    localparam or_op=  5'b01_001;
    localparam xor_op= 5'b01_010;
    localparam not_op= 5'b01_100;

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

    // Instantiate the ALU
    ALU_test alu_instance(
        .A(operand_A),
        .B(operand_B),
        .alu_code(operation_code),
        .coe(carry_out_enable),
        .C(result),
        .vout(overflow),
        .cout(carry_out)
    );

    initial begin
        // Populate operation list and names
        op_list[0]  = add;     op_names[0] = "ADD";
        op_list[1]  = addu;    op_names[1] = "ADDU";
        op_list[2]  = sub;     op_names[2] = "SUB";
        op_list[3]  = subu;    op_names[3] = "SUBU";
        op_list[4]  = inc;     op_names[4] = "INC";
        op_list[5]  = dec;     op_names[5] = "DEC";
        op_list[6]  = and_op;  op_names[6] = "AND";
        op_list[7]  = or_op;   op_names[7] = "OR";
        op_list[8]  = xor_op;  op_names[8] = "XOR";
        op_list[9]  = not_op;  op_names[9] = "NOT";
        op_list[10] = sll;     op_names[10] = "SLL";
        op_list[11] = srl;     op_names[11] = "SRL";
        op_list[12] = sla;     op_names[12] = "SLA";
        op_list[13] = sra;     op_names[13] = "SRA";
        op_list[14] = sle;     op_names[14] = "SLE";
        op_list[15] = slt;     op_names[15] = "SLT";
        op_list[16] = sge;     op_names[16] = "SGE";
        op_list[17] = sgt;     op_names[17] = "SGT";
        op_list[18] = seq;     op_names[18] = "SEQ";
        op_list[19] = sne;     op_names[19] = "SNE";

        // Loop through operations
        for (index = 0; index < 20; index = index + 1) begin
            operand_A = 16'hA00A;
            operand_B = 16'h1004;
            carry_out_enable = 1'b0; // active low
            operation_code = op_list[index];
            $display("Testing operation: %s (CODE: %b)", op_names[index], operation_code);
            $display("Inputs: A=%h, B=%h, CarryOutEn_L=%b | Outputs: C=%h, vout=%b, cout=%b", 
                operand_A, operand_B, carry_out_enable, result, overflow, carry_out);
            #100;
        end
        
        for (index = 0; index < 20; index = index + 1) begin
            operand_A = 16'hF14A;
            operand_B = 16'hF002;
            carry_out_enable = 1'b0;
            operation_code = op_list[index];
            $display("Testing operation: %s (CODE: %b)", op_names[index], operation_code);
            $display("Inputs: A=%h, B=%h, CarryOutEn_L=%b | Outputs: C=%h, vout=%b, cout=%b", 
                operand_A, operand_B, carry_out_enable, result, overflow, carry_out);
            #100;
        end
        
        for (index = 0; index < 20; index = index + 1) begin
            operand_A = 16'h8012;
            operand_B = 16'h8002;
            carry_out_enable = 1'b0;
            operation_code = op_list[index];
            $display("Testing operation: %s (CODE: %b)", op_names[index], operation_code);
            $display("Inputs: A=%h, B=%h, CarryOutEn_L=%b | Outputs: C=%h, vout=%b, cout=%b", 
                operand_A, operand_B, carry_out_enable, result, overflow, carry_out);
            #100;
        end
    end
endmodule

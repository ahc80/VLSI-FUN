module processor (
    input         clk,

    input  [31:0] data_in,
    output    reg reading, // 1 = read from mem, 0 write to mem
    output [11:0] address,
    output [31:0] data_out
);

    // ----- ----- Internal registers ----- ----- \\

    // Program Counter - stores next instruction mem address
    reg [11:0] PC;
    // Instruction Counter - FETCH, DECODE, EXEC, etc
    reg [ 3:0] IC;
    // Instruction Register  - [31:28 - OPcode][27:24 - CC][27:26 - src,dest reg&mem/imm][23:12 - srcsAddrs/shiftOrRotate][11:0 - dest]
    reg [31:0] IR;
    // Processor Status Register - [4 - Zero][3 - Negative][2 - Even][1 - Parity][0 - Carry]
    reg [ 4:0] PSR; 
    // Operands - the working registers
    reg [31:0] operand1;
    reg [31:0] operand2;
    // Boolean to make halt work
    reg        isHalted;

    // Register file = memory
    reg [31:0] register_file [15:0];

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

    // Program counter
    localparam FETCH        = 3'd0;
    localparam DECODE       = 3'd1;
    localparam EXECUTE      = 3'd2;
    localparam MEM_ACCESS   = 3'd3;
    localparam WRITEBACK    = 3'd4;
 
    // ----- ----- Processor Tasks ----- ----- \\

    // Helper tasks
    task read_address(
        input [11:0] address_in
    );
        reading <= 1'b1;
        address <= address_in;
    endtask


always @(posedge clk ) begin
    if(~ isHalted) begin
        case (IC)

            (FETCH): begin
            // Retrive instructions
                reading <= 1'b1;
                address <= address_in;
                IR <= data_in;
            end

            (DECODE): begin
            // retrieve register values
                operand1 <= 
                operand2 <=
            end

            (EXECUTE): begin
                case (IR[31:28)
                    (NOP_op): begin
                        // idle
                    end

                    (LD_op): begin
                        
                    end 

                    (STR_op): begin
                        
                    end 

                    (BRA_op): begin
                        
                    end 

                    (XOR_op): begin
                        
                    end

                    (ADD_op): begin
                        
                    end 

                    (ROT_op): begin
                        
                    end 

                    (SHF_op): begin
                        
                    end 

                    (HLT_op): begin
                        
                    end 

                    (CMP_op): begin
                        
                    end

                    default: begin
                        $display($time, " ERROR! Invalid OpCode");
                    end
                endcase
            end

            (MEM_ACCESS): begin
                
            end

            (WRITEBACK): begin
                
            end
    end
end
    
endmodule
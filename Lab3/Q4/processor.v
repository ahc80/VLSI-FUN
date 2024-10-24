module processor (
    input         clk,

    input  [31:0] data_in,
    output    reg reading, // 1 = read from mem, 0 write to mem
    output [11:0] address,
    output [31:0] data_out
);

    // ----- ----- Internal registers ----- ----- \\

    // Program Counter - stores next instruction mem address
    reg [11:0] program_counter;
    // Instruction Counter - FETCH, DECODE, EXEC, etc
    reg [ 3:0] instruction_counter;
    // Instruction Register  - [31:28 - OPcode][27:24 - CC][27:26 - src,dest reg&mem/imm][23:12 - srcsAddrs/shiftOrRotate][11:0 - dest]
    reg [31:0] IR;
    // Processor Status Register - [4 - Zero][3 - Negative][2 - Even][1 - Parity][0 - Carry]
    reg [ 4:0] PSR; 
    // Operands - the working registers
    reg [31:0] dest_data;
    reg [31:0] src_data;
    // Boolean to make halt work
    reg        isHalted;
    // Boolean to handle branching
    reg        isBranching;

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

    // Shorthand
    localparam SET_PSR      = 5'b11111
 
    // ----- ----- Processor Tasks ----- ----- \\

    task set_psr_task();
        // Blindspot: I think carry from add should always be 0?
        PSR[0] <= 32'b0;
        PSR[1] <= ^ dest_data[3];
        PSR[2] <= ~ (dest_data[31] ^ dest_data[0]);  // get ready to change if bug
        PSR[3] <= dest_data[31];
        PSR[4] <= ~ (| dest_data);
    endtask

    always @(negedge clk ) begin
        // increment PC

        // OR IS THIS PART OF DECODE?
    end

    always @(posedge clk ) begin
        if(~ isHalted) begin
            case (instruction_counter)

                (FETCH): begin
                // Retrive instructions

                // Read from ram
                // Update IR
                //
                    reading <= 1'b1;
                    address <= program_counter;
                    IR      <= data_in;
                end

                (DECODE): begin
                // retrieve register values
                    dest_data <= (IR[26])? IR[11:0] : register_file[IR[3:0]];
                    src_data  <= (IR[27])? IR[23:12]: register_file[IR[15:12]];
                end

                (EXECUTE): begin
                    case (IR[31:28)
                        (NOP_op): begin
                            // idle
                        end

                        (LD_op): begin //set PSR, 0is0
                            
                        end 

                        (STR_op): begin // CLEAR PSR
                            
                        end 

                        (BRA_op): begin 
                            
                        end 

                        (XOR_op): begin //set PSR, 0is0
                            
                        end

                        (ADD_op): begin //set PSR, 0is0
                            
                        end 

                        (ROT_op): begin //set PSR, poss carry?
                            
                        end 

                        (SHF_op): begin //set PSR, 0should0?
                            
                        end 

                        (HLT_op): begin
                            
                        end 

                        (CMP_op): begin //set PSR, 0is0
                            
                        end

                        default: begin
                            $display($time, " ERROR! Invalid OpCode");
                        end
                    endcase
                end

                (MEM_ACCESS): begin
                    program_counter <= (isBranching)? IR[11:0] : program_counter + 1'b1;
                end

                (WRITEBACK): begin
                    // Write value to spot
                    case (IR[31:28])
                        (STR_op): begin
                            
                        end
                        (BRA_op): begin
                            
                        end
                        (NOP_op): begin
                            
                        end
                        default: begin
                            if(~IR[26]) begin
                                register_file[IR[11:0]] <= dest_data;
                            end
                        end
                    endcase
                end
        end
    end
        
endmodule
module processor (
    input  wire         clk,
    input  reg  [31:0]  data_in,
    output reg          reading, // 1 = read from mem, 0 write to mem
    output reg  [11:0]  program_counter, // stores next instruction mem address
    output reg  [31:0]  accumulator
);

    // Make data in a wire?

    // ----- ----- Internal registers ----- ----- \\
    // Instruction Counter - FETCH, DECODE, EXEC, etc
    reg [ 2:0] instruction_counter;
    // Instruction Register  - [31:28 - OPcode][27:24 - CC][27:26 - src,dest reg&mem/imm][23:12 - srcsAddrs/shiftOrRotate][11:0 - dest]
    reg [31:0] IR;
    // Processor Status Register - [4 - Zero][3 - Negative][2 - Even][1 - Parity][0 - Carry]
    reg [ 4:0] PSR; 
    // Spare operand
    reg [31:0] src_data;
    // Boolean to make halt work
    reg        isHalted;
    // Boolean to handle branching
    reg        isBranching;
    // Looping variable
    integer     i;

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
    localparam PO_cc = 3'd7;

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
    localparam SET_PSR      = 5'b11111;
 
    // ----- ----- Always and Initial blocks ----- ----- \\

    initial begin
        reading             =  1'b1;
        program_counter     = 12'b0;
        accumulator         = 32'b0;
        instruction_counter =  4'b0;
        IR                  = 32'b0;
        PSR                 =  5'b0;
        src_data            = 32'b0;
        isHalted            =  1'b0;
        isBranching         =  1'b0;

        for(i=0; i<16; i=i+1) begin
            register_file[i] = 32'b0;
        end
    end

    always @(posedge clk ) begin
        if(~ isHalted) begin
            case (instruction_counter)
                (FETCH): begin
                // Retrive instructions
                instruction_counter <= instruction_counter + 1;
                    if(~reading) begin
                        reading = 1'b1;
                        program_counter <= src_data;  
                    end
                    #3
                    IR <= data_in;
                end

                (DECODE): begin
                instruction_counter <= instruction_counter + 1;
                // retrieve register values
                    accumulator <= (IR[26])? IR[11:0] : register_file[IR[3:0]];
                    src_data    <= (IR[27])? IR[23:12]: register_file[IR[15:12]];
                    
                end

                (EXECUTE): begin
                    instruction_counter <= instruction_counter + 1;
                    case (IR[31:28])
                        (NOP_op): begin
                            // idle
                        end

                        (LD_op): begin //set PSR, 0is0
                            accumulator <= src_data;
                        end 

                        (STR_op): begin // CLEAR PSR
                            accumulator <= src_data;
                            PSR <= 5'b0;
                        end 

                        (BRA_op): begin 
                            case (IR[14:12])    // My CC is the 3 LSBs of src
                                (A_cc): begin
                                    isBranching <= 1;
                                end
                                (P_cc): begin
                                    isBranching <= PSR[1];
                                end 
                                (E_cc): begin
                                    isBranching <= PSR[2];
                                end 
                                (C_cc): begin
                                    isBranching <= PSR[0];
                                end 
                                (N_cc): begin
                                    isBranching <= PSR[3];
                                end 
                                (Z_cc): begin
                                    isBranching <= PSR[4];
                                end 
                                (NC_cc): begin
                                    isBranching <= ~PSR[0];
                                end 
                                (PO_cc): begin
                                    isBranching <= ~PSR[3];
                                end 
                                default: begin
                                    $display($time, " Invalid CC");
                                end
                            endcase
                        end 

                        (XOR_op): begin
                            accumulator <= accumulator ^ src_data;
                        end

                        (ADD_op): begin
                            accumulator[11:0] <= accumulator + src_data + PSR[0];
                        end 

                        (ROT_op): begin
                            if(src_data[31]) begin
                                accumulator <= accumulator >>> src_data;
                            end else begin
                                accumulator <= accumulator <<< src_data;
                            end
                        end 

                        (SHF_op): begin
                            if(src_data[31]) begin
                                accumulator <= accumulator >> src_data;
                            end else begin
                                accumulator <= accumulator << src_data;
                            end
                        end 

                        (HLT_op): begin
                            isHalted <= 1;
                            $display($time, " Program Halted.");
                            for(i=0;i<16; i=i+1) begin
                                $display($time, " Register %d value: %d", i, register_file[i]);
                            end
                        end 

                        (CMP_op): begin
                            accumulator <= (~src_data) + 1;
                        end

                        default: begin
                            $display($time, " ERROR! Invalid OpCode");
                        end
                    endcase
                end

                (MEM_ACCESS): begin
                    instruction_counter <= instruction_counter + 1;
                    program_counter <= (isBranching)? IR[11:0] : program_counter + 1'b1;
                    isBranching <= 0;
                    if(~STR_op && ~NOP_op && ~BRA_op && ~HLT_op) begin
                        PSR[0] <= 0;
                        PSR[1] <= ^ accumulator[30:0];
                        PSR[2] <= ~ (accumulator[31] ^ accumulator[0]);
                        PSR[3] <= accumulator[11];  // fitted for 12 bit 2's comp
                        PSR[4] <= ~|accumulator;
                    end
                end

                (WRITEBACK): begin
                    instruction_counter <= 0;
                    // Write value to spot
                    case (IR[31:28])
                        (STR_op): begin
                            // Special case: src_data saves the next program counter value
                            reading <= 0;
                            program_counter <= accumulator;
                            src_data <= program_counter; 
                        end
                        (BRA_op): begin
                            // No operation
                        end
                        (NOP_op): begin
                            // No operation
                        end
                        default: begin
                            if(~IR[26]) begin
                                register_file[IR[11:0]] <= accumulator;
                            end
                        end
                    endcase
                end
            endcase
        end else begin
            $finish;
        end
    end
        
endmodule
module txfifo (
    input            PSEL,
    input            PWRITE,
    input            CLEAR_B,
    input            PCLK,
    input      [7:0] PWDATA,
    input            transmit_complete, // go to next output @ posedge
    output reg       tx_ready,          // flag when output is readable
    output reg [7:0] TxData,
    output reg       SSPTXINTR
    );
    reg [7:0] data_reg [3:0];
    reg [1:0] in_ptr;           // Points to location where PWDATA will be written
    reg [1:0] out_ptr;          // Points to first-written PWDATA

    initial begin
        data_reg[0] = 8'b0;
        data_reg[1] = 8'b0;
        data_reg[2] = 8'b0;
        data_reg[3] = 8'b0;
        in_ptr = 2'b0;
        out_ptr= 2'b0;
        tx_ready = 1'b0;
        SSPTXINTR = 1'b0;
    end

    // Handle reading PWDATA
    always @(posedge PCLK) begin
        if(PSEL && PWRITE && ~SSPTXINTR && PWDATA != data_reg[in_ptr-1]) begin
            data_reg[in_ptr] <= PWDATA;
            SSPTXINTR <= (in_ptr + 1'b1 == out_ptr);
            in_ptr <= in_ptr + 1'b1;
        end
    end

    // Handle writing to Logic & clearing vaalues
    always @(posedge PCLK) begin
        if(~ CLEAR_B) begin
            data_reg[0] = 8'b0;
            data_reg[1] = 8'b0;
            data_reg[2] = 8'b0;
            data_reg[3] = 8'b0;
            in_ptr = 2'b0;
            out_ptr= 2'b0;
            tx_ready = 1'b0;
            SSPTXINTR = 1'b0;
        end else begin
            if(transmit_complete && (in_ptr != out_ptr || SSPTXINTR)) begin    // ~tx_ready in statement should be redundant
                TxData <= data_reg[out_ptr];
                tx_ready <= 1'b1;
                #3 out_ptr <= out_ptr + 1'b1;
                #3 SSPTXINTR <= 1'b0;
                #3 tx_ready <= 1'b0;
            end
        end
    end
endmodule
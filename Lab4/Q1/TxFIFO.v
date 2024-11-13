module txfifo (
    input        PSEL,
    input        PWRITE,
    input        CLEAR_B,
    input        PCLK,
    input  [7:0] PWDATA,
    input        transmit_complete, // go to next output @ posedge
    output       tx_ready,          // flag when output is readable
    output [7:0] TxData,
    output       SSPTXINTR
    );
    reg [7:0] data_reg [3:0];
    reg [1:0] in_ptr;           // Points to location where PWDATA will be written
    reg [1:0] out_ptr;          // Points to first-written PWDATA

    // Handle reading PWDATA
    always @(posedge PCLK) begin
        if(PSEL && PWRITE && ~SSPTXINTR && PWDATA != data_reg[in_ptr-1]) begin
            data_reg[in_ptr] <= PWDATA;
            SSPTXINTR <= (in_ptr + 1'b1 == out_ptr);
            in_ptr <= in_ptr + 1'b1;
        end
    end

    // Handle writing to Logic
    always @(posedge PCLK) begin
        if( transmit_complete && /*~tx_ready && do we need it? */ (in_ptr != out_ptr || SSPTXINTR)) begin    // ( ) && Transmit complete? So we dont move on by accident?
            TxData <= data_reg[out_ptr];
            tx_ready <= 1'b1;                        // Need to lower this signal somehow
            /*
            --> Now handled by transmit complete
            out_ptr <= out_ptr + 1'b1;
            SSPTXINTR <= 1'b0;
            */
        end
    end

    // Handle
    always @(posedge transmit_complete) begin       // Does this work?
        tx_ready = 1'b0;
    end

    // Handle 
    always @(negedge transmit_complete) begin       // Negedge?
        out_ptr = out_ptr + 1'b1;
        SSPTXINTR = 1'b0;
    end

endmodule
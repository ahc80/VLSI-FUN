module rxfifo (
    input        PSEL,
    input        PWRITE,
    input        CLEAR_B,
    input        PCLK,
    input  [7:0] RxData,
    input        rx_ready, // <-- (rx_ready) high when input data is readable
    output reg   SSPRXINTR,
    output reg [7:0] PRDATA
);
    // Will never try to read empty; Readptr will never increment past Writeptr
    reg [7:0] data_reg [3:0];
    reg [1:0] read_ptr;
    reg [1:0] write_ptr;

    // Initialize (and clear) values
    initial begin
        data_reg[0] = 8'b0;
        data_reg[1] = 8'b0;
        data_reg[2] = 8'b0;
        data_reg[3] = 8'b0;
        SSPRXINTR = 1'b0;
        read_ptr  = 1'b0;
        write_ptr = 1'b0;
    end


    // Handle  clearing values & inputting data to memory & reading out memory to PRDATA
    always @(posedge PCLK) begin
        if(~CLEAR_B) begin
            data_reg[0] = 8'b0;
            data_reg[1] = 8'b0;
            data_reg[2] = 8'b0;
            data_reg[3] = 8'b0;
            SSPRXINTR = 1'b0;
            read_ptr = 1'b0;
            write_ptr = 1'b0;
        end else begin
            // Input data from logic into memory
            if(~SSPRXINTR && rx_ready && RxData != data_reg[write_ptr-2'b1]) begin
                data_reg[write_ptr] <= RxData;
                write_ptr <= write_ptr + 2'b1;
                SSPRXINTR <= (write_ptr + 2'b1 == read_ptr);
            end
            // Output data to PRDATA
            if(PSEL && ~PWRITE && (read_ptr != write_ptr || SSPRXINTR)) begin
                PRDATA <= data_reg[read_ptr];
                read_ptr <= read_ptr + 2'b1;
                SSPRXINTR = 1'b0;
            end
        end
    end
endmodule
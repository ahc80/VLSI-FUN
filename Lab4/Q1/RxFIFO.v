module rxfifo (
    input        PSEL,
    input        PWRITE,
    input  [7:0] RxData,
    input        CLEAR_B,
    input        PCLK,
    
    input        rx_readable, // <-- (rx_ready) high when input data is readable
    
    output       SSPTXINTR,
    output [7:0] TxData
);
    
    reg [7:0] data_reg [3:0];
    reg [1:0] read_ptr;
    reg [1:0] write_ptr;
    // How will we store the data?


    initial begin
        SSPTXINTR = 0;
        read_ptr = 0;
        write_ptr = 0;
    end

    always @(posedge rx_ready) begin
        data_reg[write_ptr] <= RxData;
        write_ptr
    end
endmodule
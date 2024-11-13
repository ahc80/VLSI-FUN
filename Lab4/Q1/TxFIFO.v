module txfifo (
    input        PSEL,
    input        PWRITE,
    input        CLEAR_B,
    input        PCLK,
    input  [7:0] TxData,
    input        transmit_complete, // go to next output @ posedge
    output       tx_ready,          // flag when output is readable
    output [7:0] PWDATA
);
    


endmodule
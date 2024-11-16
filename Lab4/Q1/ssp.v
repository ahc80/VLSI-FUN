module ssp (
    input        PCLK,
    input        CLEAR_B,
    input        PSEL,
    input        PWRITE,
    input [7:0]  PWDATA,
    input        SSPCLKIN,
    input        SSPFSSIN,
    input        SSPRXD,
    output [7:0] PRDATA,
    output       SSPOE_B,
    output       SSPTXD,
    output       SSPCLKOUT,
    output       SSPFSSOUT,
    output       SSPTXINTR,
    output       SSPRXINTR  
);

    wire transmit_complete;
    wire tx_ready;
    wire rx_ready;
    wire [7:0] TxData;
    wire [7:0] RxData;

    txfifo txf (
        .PSEL(PSEL),
        .PWRITE(PWRITE),
        .CLEAR_B(CLEAR_B),
        .PCLK(PCLK),
        .PWDATA(PWDATA),
        .transmit_complete(transmit_complete),
        .tx_ready(tx_ready),
        .TxData(TxData),
        .SSPTXINTR(SSPTXINTR)
    );

    rxfifo rxf (
        .PSEL(PSEL),
        .PWRITE(PWRITE),
        .CLEAR_B(CLEAR_B),
        .PCLK(PCLK),
        .RxData(RxData),
        .rx_ready(rx_ready),
        .SSPRXINTR(SSPRXINTR),
        .PRDATA(PRDATA)
    );

    trlogic trl (
        .PCLK(PCLK),
        .SSPCLKIN(SSPCLKIN),
        .SSPFSSIN(SSPFSSIN),
        .SSPRXD(SSPRXD),
        .tx_ready(tx_ready),
        .TxData(TxData),
        .RxData(RxData),
        .rx_ready(rx_ready),
        .transmit_complete(transmit_complete),
        .SSPOE_B(SSPOE_B),
        .SSPTXD(SSPTXD),
        .SSPFSSOUT(SSPFSSOUT),
        .SSPCLKOUT(SSPCLKOUT)
    );
endmodule
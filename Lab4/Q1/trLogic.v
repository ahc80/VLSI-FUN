module trlogic (
    input            PCLK,
    input            SSPCLKIN,
    input            SSPFSSIN,
    input            SSPRXD,
    input            tx_ready,  // High when TxF has data ready
    input      [7:0] TxData,
    output reg [7:0] RxData,    // Need a outputting signal
    output reg       rx_ready,  // High when trL has finished preparing input
    output reg       transmit_complete, // Transmit complete gets TxF to show next word
    output           SSPOE_B,
    output           SSPTXD,
    output           SSPFSSOUT,
    output wire      SSPCLKOUT
);

    reg receiving;
    reg [2:0] rxdata_ptr;
    reg [2:0] txdata_ptr;

    assign SSPCLKOUT = PCLK;

    initial begin
        rxdata_ptr = 3'd7;
        txdata_ptr = 3'd7;
        receiving = 0;
        rx_ready = 0;
        transmit_complete = 1;      // Start as 1; Ready to start transmitting from the get go
    end

    // ------ ------ Receiving Logic ------ ------ \\

    always @(posedge SSPFSSIN) begin
        receiving <= 1'b1;
        rx_ready  <= 0;
    end

    always @(posedge SSPCLKIN) begin
        if(receiving) begin
            RxData[rxdata_ptr] <= SSPRXD;
            // Increment ptr
            if( rxdata_ptr > 0) begin
                rxdata_ptr <= rxdata_ptr - 1;
            end else begin
                rxdata_ptr <= rxdata_ptr - 1;
                receiving  <= 1'b0;
                rx_ready   <= 1;
            end
        end
    end

    // ------ ------ Transmitting Logic ------ ------ \\

    // is it smarty to just posedge tx_ready?
    always @(posedge SSPCLKOUT) begin // Both in one wouldnt cause an issue right?
        // Catch ready signal to start transmission
        if(tx_ready) begin
            transmit_complete <= 0;
            SSPFSSOUT <= 1;
        end
        // Transmit data once ready signal caught and lower SSPFSSOUT
        if(~transmit_complete) begin
            SSPTXD <= TxData[txdata_ptr];
            SSPFSSOUT <= 0;
            if(txdata_ptr > 0) begin
                txdata_ptr <= txdata_ptr - 1;
            end else begin
                txdata_ptr <= txdata_ptr - 1;
                transmit_complete <= 1;
            end
        end
    end

endmodule
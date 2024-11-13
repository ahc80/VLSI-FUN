module trlogic (
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
    output           SSPCLKOUT
);

    reg receiving;
    reg transmitting;
    reg [2:0] rxdata_ptr;
    reg [2:0] txdata_ptr;

    initial begin
        rxdata_ptr = 3'd7;
        txdata_ptr = 3'd7;
        receiving = 0;
        rx_ready = 0;
        transmitting = 0;
        transmit_complete = 0;

        SSPCLKOUT = 0;
    end

    always begin
        #1 SSPCLKOUT = ~SSPCLKOUT;  // Just make synced to PCLK?
    end

    // ------ ------ Receiving Logic ------ ------ \\

    always @(posedge SSPFSSIN) begin
        receiving <= 1'b1;
        rx_ready     <= 0;
    end

    always @(posedge SSPCLKIN) begin
        if(receiving) begin
            RxData[rxdata_ptr] <= SSPRXD;
        end
    end

    always @(negedge SSPCLKIN) begin    // Lowkey... does it still work with nonblocking?
        if(receiving) begin
            if( rxdata_ptr > 0) begin
                rxdata_ptr = rxdata_ptr - 1;
            end else begin
                rxdata_ptr = rxdata_ptr - 1;
                receiving  = 1'b0;
                rx_ready   = 1;
            end
        end
    end

    // ------ ------ Transmitting Logic ------ ------ \\

    always @(posedge SSPFSSOUT) begin // More like at TxF ready
        transmitting <= 1;
        transmit_complete <= 0;
        // Not quite sure how Ill control the clock... it should always be fluctuating so...
        //
        // Why not the SSPCLKOUT is always changing

        // Idea for signal in TxF where it has always ready = ~ready on posedge
        // So you can just flip it to 1 rq every time you finished preparing the next set
    end

    // |||||||||||
    // |||||||||||
    // VVVVVVVVVVV

    // is it smarty to just posedge tx_ready?
    always @(posedge SSPCLKOUT) begin // Both in one wouldnt cause an issue right?
        // Catch ready signal to start transmission
        if(tx_ready) begin
            transmitting <= 1;
            transmit_complete <= 0;
            SSPFSSOUT = 1;
        end
        // Lower SSPFSSOUT to follow diagram
        if(SSPFSSOUT) begin
            SSPFSSOUT = 0;
        end
        // Transmit data once ready signal caught
        if(transmitting) begin
            SSPTXD = TxData[txdata_ptr];
        end
    end

    always @(negedge SSPCLKOUT) begin
        if(transmitting) begin              // this would increment one BEFORE first writing step... I think?
            if(txdata_ptr > 0) begin
                txdata_ptr = txdata_ptr - 1;
            end else begin
                txdata_ptr = txdata_ptr - 1;
                transmitting = 0;
                transmit_complete = 1;
            end
        end
    end

    /*
    always @(posedge transmit_complete ) begin      // this code is problematic
        #1 transmit_complete <= ~transmit_complete;
    end

    ||||||||
    VVVVVVVV
    */

endmodule
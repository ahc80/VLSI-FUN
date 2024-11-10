module trlogic (
    input            SSPCLKIN,
    input            SSPFSSIN,
    input            SSPRXD,
    input      [7:0] TxData,
    output reg [7:0] RxData, // Need a outputting signal
    output reg [2:0] rxdata_ptr,
    output           SSPOE_B,
    output           SSPTXD,
    output           SSPFSSOUT,
    output           SSPCLKOUT,
);

    initial begin
        rxdata_ptr = 3'd7;
    end

    // About rx ptr
    // When its 7 its on standby


    always @(posedge SSPCLKIN && /* Enable or ReadWrite*/ ) begin
        RxData[rxdata_ptr] <= SSPRXD;
        rxdata_ptr <= rxdata_ptr - 1;   // Possible mess up?
    end


endmodule
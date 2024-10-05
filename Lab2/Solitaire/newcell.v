module myfreecell(
    input           clock, 
    input   [3:0]   source,
    input   [3:0]   dest,
    output  reg     win
    );

    // ----- ----- Card type shorthands ----- ----- \\

    // Declaring card types
    // 4'b0000 = blank slot
    localparam ace      = 4'd1;
    localparam two      = 4'd2;
    localparam three    = 4'd3;
    localparam four     = 4'd4;
    localparam five     = 4'd5;
    localparam six      = 4'd6;
    localparam seven    = 4'd7;
    localparam eight    = 4'd8;
    localparam nine     = 4'd9;
    localparam ten      = 4'd10;
    localparam joker    = 4'd11;
    localparam queen    = 4'd12;
    localparam king     = 4'd13;

    // Declaring suits
    localparam hearts   = 2'b00; // redsuit
    localparam spades   = 2'b01; // blacksuit
    localparam clubs    = 2'b10; // blacksuit
    localparam diamonds = 2'b11; // redsuit

    // XOR = 1 means blacksuit
    // XOR = 0 means redsuit

    // ----- ----- Storage (arranged after tasks) ----- ----- \\

    reg [5:0] free_cells [3:0];
    reg [5:0] home_cells [3:0][12:0]; // 0: Hearts  1: Spades  2: Clubs  3: Diamonds
    reg [5:0] tableau    [7:0][29:0];

    reg [3:0] free_pointer[3];
    reg [3:0] hom_pointer;






endmodule
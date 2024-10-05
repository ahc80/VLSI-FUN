module freecellPlayer(
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
    reg [3:0] home_full_list; // 1 if full. MSB -> LSB: Diamonds, Clubs, Spades, Hearts
    reg [5:0] temp_card;


    // ----- ----- Functions & Tasks ----- ----- \\

    function automatic [5:0] read_source(
        input [3:0] src
    );
        casez (src[3:0])
            (4'b0???): begin
            // Col of tableau
                read_source[5:0] = tableau_read(src[2:0]);
            end
            (4'b10??): begin
            // Free cell
                read_source[5:0] = free_read(src[1:0]);
            end
            default: begin
                read_source[5:0] = 5'd0;
                $display("Something wrong with read_source");
            end
        endcase
    endfunction

    function automatic write_dest(
        input [3:0] dest,
        input [5:0] card
    );
        casez(dest[3:0])
            (4'b0???): begin // case tableau
                write_dest  = tableau_write(dest[3:0], card[5:0]);
            end
            (4'b10??): begin // case free
                write_dest  = free_write(dest[3:0], card[5:0]);
            end
            (4'b11??): begin // case home
                write_dest = home_write(dest[3:0], card[5:0]);
            end
            default: begin
                $display("Error occured; defaulted write_dest");
            end 
        endcase
    endfunction

    task automatic remove_source(  
        input [3:0] source
    );
        casez(source[3:0])
            (4'b0???): begin
                tableau_remove(source[3:0]);
            end
            (4'b10??):begin
                free_remove(source[3:0]);
            end
            (4'b11??): begin
                $display("Error, remove_source got 4'b11??");
            end
            default: begin
                $display("Error occured; defaulted remove_source");
            end 
        endcase
    endtask
    
    // -- Free_cells Tasks -- \\\
    // Read free cell card in slot
    function automatic [5:0] free_read(
        input [1:0] free_cell_col
    );
    free_read[5:0] = free_cells[free_cell_col[1:0]];
    endfunction

    // Place card in free cell. Automatically checks legality
    function automatic free_write(
        input  [3:0]    dest,
        input  [5:0]    card
    );
        reg [1:0] free_cell_col;
        begin
            free_cell_col = dest[1:0];
            if(free_cells[free_cell_col] == 6'd0 ) begin
                free_cells[free_cell_col] = card[5:0];
                free_write = 1; 
            end else begin
                free_write = 0;
                $display("Illegal move detected! Skipping turn...");
            end
        end
    endfunction

    // Make given free cell slot empty
    task automatic free_remove(
        input [3:0] source
    );
        free_cells[source[1:0]] = 6'd0;
    endtask


    // -- Home_cells Tasks -- \\\
    // Ace goes first; Ace goes in 0 slot

    function automatic [5:0] home_read(
        input [1:0] suit
    );
    integer i;
    integer notFound;
    begin
        notFound = 1;
        if(home_cells[suit][0][3:0] == 4'd0) begin
            home_read = 6'd0;
        end else begin
            //  reg [5:0] home_cells [3:0][12:0];
            for(i=12; i>0; i=i-1) begin
                if(home_cells[suit][i][3:0] != 4'd0
                && notFound) begin
                    home_read = home_cells[suit][i];
                    notFound = 0;
                end
            end
        end
    end
    endfunction

    // automatically checks legality
    function automatic home_write(
        input [3:0] dest,
        input [5:0] card
    );
    integer       isIllegal; // 0 means legal, 1 means illegal
    integer       i;
    reg     [1:0] suit;
    begin
        suit = dest[1:0];

        isIllegal = 1;
        if(suit == card[5:4]) begin
            for(i=11; i>=0; i=i-1) begin
                if(home_cells[suit][i][3:0] != 4'd0 
                && card[3:0] == home_cells[suit][i][3:0] + 1'b1
                && isIllegal) begin
                    isIllegal = 0;
                    home_cells[suit][i+1] = card;
                    home_write = 1;
                end
            end
        end
        if(isIllegal) begin
            $display("Illegal move detected! Skipping turn...");
            home_write = 0;
        end
    end
    endfunction


    // -- Tableau Tasks -- \\\

    // reg [5:0] tableau[7:0][29:0];

    function automatic [5:0] tableau_read (
        input [2:0] col
    );
        integer isEmpty;
        integer i;
        begin
            isEmpty = 1;
            for(i=29; i>=0; i=i-1) begin
                if(tableau[col][i][3:0] != 4'd0
                && isEmpty) begin
                    isEmpty = 0;
                    tableau_read = tableau[col][i];
                end
            end
            if(isEmpty) begin
                tableau_read = 6'd0;
            end
        end
    endfunction


    function automatic tableau_write(
        input [3:0] dest,
        input [5:0] card
    );
        integer         isIllegal;
        integer         i;
        reg     [5:0]   temp_card;
        reg     [2:0]   col;
        begin
            col = dest[2:0];
            isIllegal = 1;
            for(i=28;i>=0;i=i-1) begin
                // Find first not empty slot
                if(tableau[col][i][3:0] != 4'd0) begin
                    temp_card = tableau[col][i][5:0];
                    // If cards are different suits && descending order
                    if((temp_card[1] ^ temp_card[0]) ^ (card[5] ^ card[4])
                    && temp_card[3:0] == card[3:0] + 1'b1
                    && isIllegal) begin
                        tableau[col][i+1][5:0] = card[5:0];
                        isIllegal = 0;
                        tableau_write = 1;
                    end
                end
            end
            if(isIllegal) begin
                $display("Illegal move detected! Skipping turn...");
                tableau_write = 0;
            end
        end
    endfunction


    task automatic tableau_remove(
        input [3:0] source
    );
        integer i;
        reg [2:0] col;
        integer didNotRemove;
        begin
            didNotRemove = 1;
            col = source[2:0];
            for(i=29; i>=0; i=i-1) begin
                if(tableau[col][i][3:0] != 4'd0
                && didNotRemove) begin
                    didNotRemove = 0;
                    tableau[col][i][3:0] = 6'd0;
                end
            end
            if(didNotRemove) begin
                $display("Error removing col card!");
            end
        end
    endtask

    // Automatically sets win to 1 if applicable
    task checkWin();
        // HOME FULL LIST MOVED TO NORMAL STORAGE !
        // reg [3:0] home_full_list;
        // 1 if full. MSB -> LSB: Diamonds, Clubs, Spades, Hearts
        integer l;
        begin
            for(l=0; l<4; l=l+1) begin
                home_full_list[l] = home_read(l) == 4'd13;
            end
            if(home_full_list == 4'b1111) begin
                win = 1;
                $display("Game has been won!");
            end
        end
    endtask


    // ----- ----- Arranging storage ----- ----- \\

    // initialize values
    integer i, j;
    initial begin
        
        $display("Ladies and Gentlemen, we made it to initial");

        // Fill all tableau values with blank cards
        for (i=0; i<8; i=i+1) begin
            for (j=0; j<30; j=j+1) begin
                tableau[i][j] = 6'd0;
            end
        end

        // Fill home cell values with blank cards
        for(i=0; i<4; i=i+1) begin
            for(j=0; j<13; j=j+1) begin
                home_cells[i][j] = {i, 4'b0000};
            end
        end

        // Fill all free cells with blank cards
        for (i=0; i<4; i=i+1) begin
            free_cells[i]= 6'd0;
        end
        
        // Win = 0
        win = 1'b0;

        // Assigning tableau values

        tableau[0][0] = {spades   , four  };
        tableau[0][1] = {diamonds , joker };
        tableau[0][2] = {diamonds , ten   };
        tableau[0][3] = {diamonds , six   };
        tableau[0][4] = {spades   , three };
        tableau[0][5] = {diamonds , ace   };
        tableau[0][6] = {hearts   , ace   };

        tableau[1][0] = {spades   , five  };
        tableau[1][1] = {spades   , ten   };
        tableau[1][2] = {hearts   , eight };
        tableau[1][3] = {clubs    , four  };
        tableau[1][4] = {hearts   , six   };
        tableau[1][5] = {hearts   , king  };
        tableau[1][6] = {hearts   , two   };

        tableau[2][0] = {spades   , joker };
        tableau[2][1] = {clubs    , seven };
        tableau[2][2] = {clubs    , nine  };
        tableau[2][3] = {clubs    , six   };
        tableau[2][4] = {clubs    , two   };
        tableau[2][5] = {spades   , king  };
        tableau[2][6] = {clubs    , ace   };

        tableau[3][0] = {hearts   , four  };
        tableau[3][1] = {spades   , ace   };
        tableau[3][2] = {clubs    , queen };
        tableau[3][3] = {clubs    , five  };
        tableau[3][4] = {spades   , seven };
        tableau[3][5] = {hearts   , nine  };
        tableau[3][6] = {spades   , eight };

        tableau[4][0] = {diamonds , queen };
        tableau[4][1] = {hearts   , joker };
        tableau[4][2] = {spades   , queen };
        tableau[4][3] = {spades   , six   };
        tableau[4][4] = {diamonds , two   };
        tableau[4][5] = {spades   , nine  };

        tableau[5][0] = {diamonds , five  };
        tableau[5][1] = {diamonds , king  };
        tableau[5][2] = {clubs    , three };
        tableau[5][3] = {diamonds , nine  };
        tableau[5][4] = {hearts   , three };
        tableau[5][5] = {spades   , two   };

        tableau[6][0] = {hearts   , five  };
        tableau[6][1] = {diamonds , three };
        tableau[6][2] = {hearts   , queen };
        tableau[6][3] = {diamonds , seven };
        tableau[6][4] = {clubs    , king  };
        tableau[6][5] = {clubs    , ten   };

        tableau[7][0] = {clubs    , joker };
        tableau[7][1] = {diamonds , four  };
        tableau[7][2] = {hearts   , ten   };
        tableau[7][3] = {clubs    , eight };
        tableau[7][4] = {hearts   , seven };
        tableau[7][5] = {diamonds , eight };
    end


    // ----- ----- Turn execution system ----- ----- \\
    // Play a turn
    always @(posedge clock) begin
        if(~ win) begin
            $display("We made it this far thankfully");
            temp_card = read_source(source);
            // If source movable (not moving from home && if source not empty)
            if(source[3:2] != 3'b11 && temp_card[3:0] != 4'd0) begin
                // If destination is legal (automatically writes card if legal)
                if(write_dest(dest, temp_card)) begin
                    remove_source(source);
                end
            end else begin
                $display("Illegal move detected! Skipping turn...");
            end
        end else begin
            $display("Game has been won!");
        end
        checkWin();
    end

endmodule
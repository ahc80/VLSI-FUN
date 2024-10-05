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
    reg [5:0] temp_card;

    reg [3:0] home_pointer   [3:0];
    reg [4:0] tableau_pointer[7:0];


    // ----- ----- Functions & Tasks ----- ----- \\

    function automatic [5:0] read_source(
        input [3:0] src
    );
        reg [5:0] temp;
        begin
            casez (src[3:0])
                (4'b0???): begin
                // Col of tableau
                    temp = tableau_read(src[2:0]);
                    read_source[5:0] = temp;
                end
                (4'b10??): begin
                // Free cell
                    temp[5:0] = free_read(src[1:0]);
                    read_source[5:0] = temp;
                end
                default: begin
                    temp[5:0] = 5'd0;
                    $display($time," Something wrong with read_source");
                    read_source[5:0] = temp;
                end
            endcase
        end
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
                $display($time," Error occured; defaulted write_dest");
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
                $display($time," Error, remove_source got 4'b11??");
            end
            default: begin
                $display($time," Error occured; defaulted remove_source");
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
                $display($time," Free wrote!");
            end else begin
                free_write = 0;
                $display($time," Illegal move detected by free_write! Skipping turn...");
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
    home_read = home_pointer[suit];
    endfunction

    // automatically checks legality
    function automatic home_write(
        input [3:0] dest,
        input [5:0] card
    );
    reg [1:0] suit;
    begin
        suit = card[5:4];

        // If empty home and card is ace, write
        if(home_pointer[suit]==0 
        && home_cells[suit][home_pointer[suit]][3:0] == 4'd0 ) begin
            $display($time," Home wrote ace!");
            home_cells[suit][home_pointer[suit]] = card;
            home_write = 1;
        end else begin
            // If there is non-ace and card follows order, write
            if(home_cells[suit][home_pointer[suit]][3:0] != 4'd0 
            && card[3:0] == home_cells[suit][home_pointer[suit]][3:0] + 1'b1) begin
                $display($time," Home wrote nonace!");
                home_pointer[suit] = home_pointer[suit] + 1;
                home_cells[suit][home_pointer[suit]][5:0] = card;
                home_write = 1;
            end else begin
                home_write = 0;
                $display($time," Illegal move detected by home_write! Skipping turn...");
            end
        end
    end
    endfunction


    // -- Tableau Tasks -- \\\

    // reg [5:0] tableau[7:0][29:0];

    function automatic [5:0] tableau_read (
        input [2:0] col
    );
        tableau_read = tableau[col][tableau_pointer[col]];
    endfunction


    function automatic tableau_write(
        input [3:0] dest,
        input [5:0] card
    );
        reg [2:0] col;
        reg [5:0] tab_card;
        begin
            col = dest[2:0];
            tab_card = tableau[col][tableau_pointer[col]][5:0];

            //If tableau empty (ptr is 0 and points to no value)
            if(tableau_pointer[col] == 0
            && tableau[col][tableau_pointer[col]][3:0] == 4'd0) begin
                tableau[col][tableau_pointer[col]][5:0] = card;
                tableau_pointer[col] = tableau_pointer[col] + 1;
                $display($time," Tableau wrote to empty tab!");
                tableau_write = 1;
            end else begin
                $display($time, " tabptr+1=%b", tableau[col][tableau_pointer[col]]);
                $display($time, " Card math %b=%b", (card[3:0] + 1'b1), tab_card[3:0]);
                // If cards are diff suits AND descending order, write
                if(isDiffSuit(tab_card[5:4], card[5:4])
                && tab_card[3:0] == (card[3:0] + 1'b1) ) begin             // WHAT IF ITS AN ACE
                    tableau_pointer[col] = tableau_pointer[col] + 1;
                    tableau[col][tableau_pointer[col]][5:0] = card;
                    $display($time," Tableau wrote to nonempty tab!");
                    tableau_write = 1;
                end else begin
                    $display($time," Illegal move detected by tab_write! Skipping turn...");
                    tableau_write = 0;
                end 
            end          
        end
    endfunction

    function automatic isDiffSuit(
        input [1:0] A,
        input [1:0] B
    );
        integer AisBlack;
        integer BisBlack;
        begin
            if(A == 2'b00 || A == 2'b11) begin
                AisBlack = 0;
            end else begin
                AisBlack = 1;
            end
            if(B == 2'b00 || B == 2'b11) begin
                BisBlack = 0;
            end else begin
                BisBlack = 1;
            end
            isDiffSuit = AisBlack != BisBlack;
        end
    endfunction


    task tableau_remove(
        input [3:0] source
    );
        reg [2:0] col;
        begin
            col = source[2:0];
            tableau[col][tableau_pointer[col]] = 6'd0;
            if(tableau_pointer[col] != 0) begin
                tableau_pointer[col] = tableau_pointer[col] - 1;
                $display($time, " removed nonzeroth tab entry");
            end else begin
                $display($time, " removed tab; now empty");
            end
        end
    endtask

    // Automatically sets win to 1 if applicable
    task checkWin();
        // HOME FULL LIST MOVED TO NORMAL STORAGE !
        // 1 if full. MSB -> LSB: Diamonds, Clubs, Spades, Hearts
        if(home_pointer[0] == 13
        && home_pointer[1] == 13
        && home_pointer[2] == 13
        && home_pointer[3] == 13) begin
            win = 1;
        end
    endtask


    // ----- ----- Arranging storage ----- ----- \\

    // initialize values
    integer i, j;
    initial begin
        
        $display($time," Ladies and Gentlemen, we made it to initial");

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
            home_pointer[i] = 0;
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
        tableau_pointer[0] = 6;

        tableau[1][0] = {spades   , five  };
        tableau[1][1] = {spades   , ten   };
        tableau[1][2] = {hearts   , eight };
        tableau[1][3] = {clubs    , four  };
        tableau[1][4] = {hearts   , six   };
        tableau[1][5] = {hearts   , king  };
        tableau[1][6] = {hearts   , two   };
        tableau_pointer[1] = 6;

        tableau[2][0] = {spades   , joker };
        tableau[2][1] = {clubs    , seven };
        tableau[2][2] = {clubs    , nine  };
        tableau[2][3] = {clubs    , six   };
        tableau[2][4] = {clubs    , two   };
        tableau[2][5] = {spades   , king  };
        tableau[2][6] = {clubs    , ace   };
        tableau_pointer[2] = 6;

        tableau[3][0] = {hearts   , four  };
        tableau[3][1] = {spades   , ace   };
        tableau[3][2] = {clubs    , queen };
        tableau[3][3] = {clubs    , five  };
        tableau[3][4] = {spades   , seven };
        tableau[3][5] = {hearts   , nine  };
        tableau[3][6] = {spades   , eight };
        tableau_pointer[3] = 6;

        tableau[4][0] = {diamonds , queen };
        tableau[4][1] = {hearts   , joker };
        tableau[4][2] = {spades   , queen };
        tableau[4][3] = {spades   , six   };
        tableau[4][4] = {diamonds , two   };
        tableau[4][5] = {spades   , nine  };
        tableau_pointer[4] = 5;

        tableau[5][0] = {diamonds , five  };
        tableau[5][1] = {diamonds , king  };
        tableau[5][2] = {clubs    , three };
        tableau[5][3] = {diamonds , nine  };
        tableau[5][4] = {hearts   , three };
        tableau[5][5] = {spades   , two   };
        tableau_pointer[5] = 5;

        tableau[6][0] = {hearts   , five  };
        tableau[6][1] = {diamonds , three };
        tableau[6][2] = {hearts   , queen };
        tableau[6][3] = {diamonds , seven };
        tableau[6][4] = {clubs    , king  };
        tableau[6][5] = {clubs    , ten   };
        tableau_pointer[6] = 5;

        tableau[7][0] = {clubs    , joker };
        tableau[7][1] = {diamonds , four  };
        tableau[7][2] = {hearts   , ten   };
        tableau[7][3] = {clubs    , eight };
        tableau[7][4] = {hearts   , seven };
        tableau[7][5] = {diamonds , eight };
        tableau_pointer[7] = 5;
    end


    // ----- ----- Turn execution system ----- ----- \\
    // Play a turn
    always @(posedge clock) begin
        if(~ win) begin
            temp_card = read_source(source);
            $display($time, " src|dst card %b|%b", temp_card, read_source(dest));
            // If source movable (not moving from home && if source not empty)
            if(source[3:2] != 3'b11 && temp_card[3:0] != 4'd0) begin
                // If destination is legal (automatically writes card if legal)
                if(write_dest(dest, temp_card)) begin
                    remove_source(source);
                end
            end else begin
                $display($time," Illegal move detected by home src checker! Skipping turn...");
            end
        end else begin
            $display($time," Game has been won!");
        end
        checkWin();
    end

endmodule
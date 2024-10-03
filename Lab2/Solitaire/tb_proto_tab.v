module proto_tab_tb ();
    
    reg clk;
    reg card_in;
    reg in_out_switch;
    
    reg tableau_out;

    protoTableau (
    input           .clk(clk),
    input   [5:0]   .card_in(card_in)
    input   [2:0]   .in_out_switch(in_out_switch)        // [1:0] -> 10 is push in, 01 is pop out 
    output  [5:0]   .value_out(tableau_out)
);
endmodule
// 2001 verilog

module multiplexer_1bit (
    input A, 
    input B, 
    input Select_bit,
    output S,

    // For this multiplexer, a select bit value of 1 will output the A value
);

    wire A_AND_Select;
    wire B_AND_nSelect;

    not (nSelect_bit, Select_bit);
    
    and (A_AND_Select, A, Select_bit);
    and (B_AND_nSelect, B, nSelect_bit);
   
    or  (S, A_AND_Select, B_AND_nSelect);

endmodule




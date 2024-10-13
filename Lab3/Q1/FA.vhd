library ieee;
use ieee.std._logic_1164.all;

entity fullAdder is
    port (
    A, B, Cin: in std_logic; --inputs
    Sum, Cout: out std_logic; --outputs
    );

    end fullAdder;

    architecture basicFA of fullAdder is
        process (A, B, Cin)
        begin 
                Sum <= A XOR B XOR Cin;
                Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);
    end basicFA;
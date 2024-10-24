library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity controlled_adder_subtractor is
    Port (
        A : in std_logic;
        B : in std_logic;
        Diagonal : in std_logic;
        C_in : in std_logic;
        C_out : out std_logic;
        S : out std_logic
    );
end controlled_adder_subtractor;

architecture Behavioral of controlled_adder_subtractor is
    signal xor_output : std_logic;
begin
    -- XOR operation
    xor_output <= B xor Diagonal;

    -- Instantiate full_adder
    FA: entity work.full_adder
        port map (
            A => A,
            B => xor_output,
            Cin => C_in,
            Sum => S,
            Cout => C_out
        );
end Behavioral;
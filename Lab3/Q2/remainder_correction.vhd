library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arth.all;
use ieee.std_logic_unsigned.all;

entity remainder_correction is
    Port (
        A : in std_logic;
        Q_bit : in std_logic;
        Anded_with_Q : in std_logic;
        C_in : in std_logic;
        C_out : out std_logic;
        R : out std_logic
    );
end remainder_correction;

architecture Behavioral of remainder_correction is
    signal and_output : STD_LOGIC;
begin
    -- AND operation
    and_output <= Q_bit and Anded_with_Q;

    -- Instantiate full_adder
    FA: entity work.full_adder
        port map (
            A => A,
            B => and_output,
            Cin => C_in,
            Sum => R,
            Cout => C_out
        );
end Behavioral;

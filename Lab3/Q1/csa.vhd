library ieee;
use ieee.std._logic_1164.all;

entity CSA is
    port (
        x : in std_logic_vector(7 downto 0);
        x : in std_logic_vector(7 downto 0);
        c0 : in std_logic; --0 Initial Carry In
        --
        c8 : out std_logic; --output Cout
        S : out std_logic_vector(7 downto 0)
    );
end CSA;

architecture behav of CSA is
    signal carry0, carry1 : std_logic_vector (7 downto 0);
    signal sum0, sum1 : std_logic_vector (7 downto 0);
    signal carry_mux : std_logic_vector (7 downto 0);

    begin
        process 
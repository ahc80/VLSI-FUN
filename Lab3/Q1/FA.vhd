library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Full Adder Module
entity full_adder is
    port (
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC;
        Cout : out STD_LOGIC
    );
end full_adder;

architecture Behavioral_full_adder of full_adder is
begin
    -- Full adder logic for Sum and Cout
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end Behavioral_full_adder;
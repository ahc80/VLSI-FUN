-- ECSE 318
-- Andrew Chen and Audrey Michel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity conditionalSumAdder is
    port (
        x     : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input x
        y     : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input y
        c0    : in  STD_LOGIC;                     -- Initial carry-in
        cOut  : out STD_LOGIC;                     -- Final carry-out
        s     : out STD_LOGIC_VECTOR(7 downto 0)   -- 8-bit sum output
    );
end conditionalSumAdder;

architecture Behavioral of conditionalSumAdder is
    -- Intermediate signals for sums and carries for carry-in 0 and 1
    signal sum0, sum1 : STD_LOGIC_VECTOR(7 downto 0);
    signal carry0, carry1 : STD_LOGIC_VECTOR(8 downto 0);  -- Carry arrays
    signal carry_mux : STD_LOGIC_VECTOR(8 downto 0);       -- Carry selection signal

begin
    -- Initialize carry-in for both cases
    carry0(0) <= '0';
    carry1(0) <= '1'; 

    -- Explicitly initialize the first carry_mux value to the initial carry-in (c0)
    carry_mux(0) <= c0;

    -- Full adder for the first bit (special case for initialization)
    FA0_first: entity work.full_adder
        port map (
            A    => x(0),
            B    => y(0),
            Cin  => carry0(0),   -- Carry-in for sum0
            Sum  => sum0(0),
            Cout => carry0(1)
        );

    FA1_first: entity work.full_adder
        port map (
            A    => x(0),
            B    => y(0),
            Cin  => carry1(0),   -- Carry-in for sum1
            Sum  => sum1(0),
            Cout => carry1(1)
        );

    -- Carry and sum selection for the first bit
    process(c0, sum0, sum1, carry0, carry1)
    begin
        if c0 = '1' then
            s(0) <= sum1(0);
            carry_mux(1) <= carry1(1);
        else
            s(0) <= sum0(0);
            carry_mux(1) <= carry0(1);
        end if;
    end process;

    -- Generate full adders for the remaining bit positions
    gen_adders: for i in 1 to 7 generate
        -- Full adder for carry-in = 0
        FA0: entity work.full_adder
            port map (
                A    => x(i),
                B    => y(i),
                Cin  => carry0(i),
                Sum  => sum0(i),
                Cout => carry0(i+1)
            );

        -- Full adder for carry-in = 1
        FA1: entity work.full_adder
            port map (
                A    => x(i),
                B    => y(i),
                Cin  => carry1(i),
                Sum  => sum1(i),
                Cout => carry1(i+1)
            );

        -- Select the sum based on the carry from the previous stage
        process(carry_mux, sum0, sum1, carry0, carry1)
        begin
            if carry_mux(i) = '1' then
                s(i) <= sum1(i);
                carry_mux(i+1) <= carry1(i+1);
            else
                s(i) <= sum0(i);
                carry_mux(i+1) <= carry0(i+1);
            end if;
        end process;
    end generate;

    -- Final carry-out is determined by the last value of carry_mux
    cOut <= carry_mux(8);

end Behavioral;

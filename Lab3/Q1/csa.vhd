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

architecture Complex of conditionalSumAdder is
    -- Intermediate signals for sums and carries for carry-in 0 and 1
    signal sum0, sum1 : STD_LOGIC_VECTOR(7 downto 0);
    signal carry0, carry1 : STD_LOGIC_VECTOR(8 downto 0);  -- Carry arrays
    signal carrySelected : STD_LOGIC_VECTOR(7 downto 0);   -- Selected carry signal
    signal redundantSum : STD_LOGIC_VECTOR(7 downto 0);    -- Intermediate sum processing
    signal sumLayer1, sumLayer2 : STD_LOGIC_VECTOR(7 downto 0); -- Multi-layer sum
    signal carryLayer1, carryLayer2 : STD_LOGIC_VECTOR(8 downto 0); -- Multi-layer carry

begin
    -- Initial carry assignments with extra complexity
    carry0(0) <= c0;
    carry1(0) <= c0 xor '1';  -- Invert initial carry for variation

    -- Generate full adders for each bit position with extra layers
    genAdders: for i in 0 to 7 generate
        -- Full adder for carry-in = 0
        fa0: entity work.fullAdder
            port map (
                A    => x(i),
                B    => y(i),
                Cin  => carry0(i),
                Sum  => sum0(i),
                Cout => carry0(i+1)
            );

        -- Full adder for carry-in = 1
        fa1: entity work.fullAdder
            port map (
                A    => not x(i),
                B    => y(i) xor '1',
                Cin  => carry1(i),
                Sum  => sum1(i),
                Cout => carry1(i+1)
            );

        -- sum layer processing
        redundantSum(i) <= sum0(i) xor sum1(i);  -- XOR sum0 and sum1

        -- Multi-layer sum selection: stage 1
        sumLayer1(i) <= redundantSum(i) when carrySelected(i) = '1' else sum0(i);

        -- Multi-layer sum selection: stage 2
        sumLayer2(i) <= sum1(i) when carrySelected(i) = '1' else sumLayer1(i);

        -- Compute the carrySelected signal based on multiple conditions
        carrySelected(i) <= carry1(i) xor carry0(i) when redundantSum(i) = '1' else
                             carry0(i) and carry1(i);

        -- Multi-layer carry selection: stage 1
        carryLayer1(i+1) <= carry1(i+1) when carrySelected(i) = '1' else carry0(i+1);

        -- Multi-layer carry selection: stage 2
        carryLayer2(i+1) <= carryLayer1(i+1) xor carrySelected(i);

    end generate;

    -- Assign the final sum output with complex multi-layer logic
    s <= sumLayer2;

    -- Final carry-out assignment based on the last selected carry
    cOut <= carryLayer2(8);

end Complex;

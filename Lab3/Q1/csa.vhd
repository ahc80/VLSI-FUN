-- ECSE 318
-- Andrew Chen and Audrey Michel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    -- Component declaration for full_adder
    component full_adder
        port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    -- Intermediate signals for sums and carries for carry-in 0 and 1
    signal sum0, sum1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal carry0, carry1 : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal carry_mux : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');

    -- Monitor outputs of the first full adders
    signal FA0_first_sum, FA1_first_sum : STD_LOGIC := '0';
    signal FA0_first_carry, FA1_first_carry : STD_LOGIC := '0';

begin
    -- Explicitly initialize signals at the start of the simulation
    process
    begin
        carry0(0) <= c0;
        carry1(0) <= '1';  -- Assume carry-in = 1 for the sum1 case
        carry_mux(0) <= c0;
        wait for 10 ns;  -- Wait to ensure proper initialization
    end process;

    -- Full adder for the first bit
    FA0_first: full_adder
        port map (
            A    => x(0),
            B    => y(0),
            Cin  => carry0(0),
            Sum  => FA0_first_sum,
            Cout => FA0_first_carry
        );

    FA1_first: full_adder
        port map (
            A    => x(0),
            B    => y(0),
            Cin  => carry1(0),
            Sum  => FA1_first_sum,
            Cout => FA1_first_carry
        );

    -- Assign the values to sum0 and sum1 for bit 0
    sum0(0) <= FA0_first_sum;
    sum1(0) <= FA1_first_sum;
    carry0(1) <= FA0_first_carry;
    carry1(1) <= FA1_first_carry;

    -- Process to determine sum and carry_mux for the first bit
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

    -- Generate full adders for the remaining bits
    gen_adders: for i in 1 to 7 generate
        -- Full adder for carry-in = 0
        FA0: full_adder
            port map (
                A    => x(i),
                B    => y(i),
                Cin  => carry0(i),
                Sum  => sum0(i),
                Cout => carry0(i+1)
            );

        -- Full adder for carry-in = 1
        FA1: full_adder
            port map (
                A    => x(i),
                B    => y(i),
                Cin  => carry1(i),
                Sum  => sum1(i),
                Cout => carry1(i+1)
            );

        -- Determine the sum and carry_mux for bit i
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

    -- Assign the final carry-out based on the last carry_mux value
    cOut <= carry_mux(8);

end Behavioral;

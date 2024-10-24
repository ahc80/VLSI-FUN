library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BitSerialAdder is
    Port (
        clk           : in  STD_LOGIC;
        clr_n         : in  STD_LOGIC; -- Active-low clear signal
        set_n         : in  STD_LOGIC; -- Set signal to load inputs
        A             : in  STD_LOGIC; -- Serial input for addend
        B             : in  STD_LOGIC; -- Serial input for augend
        result        : out STD_LOGIC_VECTOR (8 downto 0); -- Result of the addition (9-bit output)
        serial_result : out STD_LOGIC -- Serial output of the current sum bit
    );
end BitSerialAdder;

architecture Behavioral of BitSerialAdder is
    -- Internal signals
    signal carry_reg       : STD_LOGIC := '0'; -- Carry register
    signal addend_data_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Addend data output
    signal augend_data_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Augend data output
    signal result_internal : STD_LOGIC_VECTOR(8 downto 0) := (others => '0'); -- Internal result signal
    signal full_adder_sum  : STD_LOGIC;
    signal full_adder_cout : STD_LOGIC;

begin
    -- Instantiate the Shift Register for Addend
    AddendShiftRegister: entity work.ShiftRegister8Bit
        Port map (
            clk        => clk,
            clr        => not clr_n, -- Active-low clear signal
            shift_in   => A,
            enable     => set_n, -- Enable shifting when set_n is high
            data_out   => addend_data_out
        );

    -- Instantiate the Shift Register for Augend
    AugendShiftRegister: entity work.ShiftRegister8Bit
        Port map (
            clk        => clk,
            clr        => not clr_n, -- Active-low clear signal
            shift_in   => B,
            enable     => set_n, -- Enable shifting when set_n is high
            data_out   => augend_data_out
        );

    -- Instantiate the Full Adder
    FullAdderInst: entity work.FullAdder
        Port map (
            A    => addend_data_out(0),
            B    => augend_data_out(0),
            Cin  => carry_reg,
            Sum  => full_adder_sum,
            Cout => full_adder_cout
        );

    -- Assign the internal result to the output ports
    result <= result_internal;
    serial_result <= result_internal(8);

    process(clk, clr_n)
    begin
        if clr_n = '0' then
            -- Clear phase: reset registers and counters
            carry_reg <= '0';
            result_internal <= (others => '0');

            -- Assertion to check that the carry and result registers are cleared correctly
            assert carry_reg = '0' and result_internal = (others => '0')
            report "BitSerialAdder did not clear carry or result properly" severity error;

        elsif rising_edge(clk) then
            if set_n = '0' then
                -- Operating phase: update the result and carry registers
                result_internal <= full_adder_sum & result_internal(8 downto 1); -- Update the result
                carry_reg <= full_adder_cout; -- Update the carry

                -- Assertions to check if the full adder's output is being used correctly
                assert carry_reg = full_adder_cout
                report "Carry register did not update correctly" severity error;

                assert result_internal(8) = full_adder_sum
                report "Result register did not shift in the sum bit correctly" severity error;
            end if;
        end if;
    end process;

end Behavioral;

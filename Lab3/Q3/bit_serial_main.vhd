library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    signal addend_data_out : STD_LOGIC; -- Serial output from addend shift register
    signal augend_data_out : STD_LOGIC; -- Serial output from augend shift register
    signal result_internal : STD_LOGIC_VECTOR(8 downto 0) := (others => '0'); -- Internal result signal with defined width
    signal full_adder_sum  : STD_LOGIC;
    signal full_adder_cout : STD_LOGIC;

begin
    -- Instantiate the Shift Register for Addend
    AddendShiftRegister: entity work.shift_register
        Port map (
            clk      => clk,
            rst_n    => clr_n,
            enable   => set_n,
            data_in  => A,
            data_out => addend_data_out
        );

    -- Instantiate the Shift Register for Augend
    AugendShiftRegister: entity work.shift_register
        Port map (
            clk      => clk,
            rst_n    => clr_n,
            enable   => set_n,
            data_in  => B,
            data_out => augend_data_out
        );

    -- Instantiate the Full Adder
    FullAdderInst: entity work.FullAdder
        Port map (
            A    => addend_data_out,
            B    => augend_data_out,
            Cin  => carry_reg,
            Sum  => full_adder_sum,
            Cout => full_adder_cout
        );

    result <= result_internal;
    serial_result <= result_internal(8);

    process(clk, clr_n)
    begin
        if clr_n = '0' then
            carry_reg <= '0';
            result_internal <= (others => '0'); -- Clear result_internal with defined width
        elsif rising_edge(clk) then
            if set_n = '0' then
                result_internal <= full_adder_sum & result_internal(8 downto 1); -- Shift in the sum
                carry_reg <= full_adder_cout;
            end if;
        end if;
    end process;

end Behavioral;

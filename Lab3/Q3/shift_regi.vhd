library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister8Bit is
    Port (
        clk        : in  STD_LOGIC;
        clr        : in  STD_LOGIC; -- Active-high clear signal
        shift_in   : in  STD_LOGIC; -- Serial input to shift in
        enable     : in  STD_LOGIC; -- Enable shifting when high
        data_out   : out STD_LOGIC_VECTOR(7 downto 0) -- Output of the shift register
    );
end entity ShiftRegister8Bit;

architecture Behavioral of ShiftRegister8Bit is
    signal reg_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process(clk, clr)
    begin
        if clr = '1' then
            reg_data <= (others => '0'); -- Clear the register

            -- Assertion to check that the register is cleared correctly
            assert reg_data = (others => '0')
            report "Shift register did not clear properly" severity error;

        elsif rising_edge(clk) then
            if enable = '1' then
                reg_data <= shift_in & reg_data(7 downto 1); -- Shift right, serial load

                -- Assertion to check if the shifting is happening as expected
                assert reg_data(7) = shift_in
                report "Shift register did not shift in the serial input correctly" severity error;
            end if;
        end if;
    end process;

    data_out <= reg_data;
end Behavioral;

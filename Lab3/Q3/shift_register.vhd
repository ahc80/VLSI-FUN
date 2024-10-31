library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        load       : in  STD_LOGIC;
        data_in    : in  STD_LOGIC_VECTOR (7 downto 0);
        shift_out  : out STD_LOGIC;
        shift_reg  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end entity ShiftRegister;

architecture Behavioral of ShiftRegister is
    signal internal_reg : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            internal_reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                internal_reg <= data_in;
            else
                internal_reg <= '0' & internal_reg(7 downto 1);
            end if;
        end if;
    end process;

    shift_out <= internal_reg(0);
    shift_reg <= internal_reg;

end Behavioral;

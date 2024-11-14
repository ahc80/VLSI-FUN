library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TagRAM is
    Port ( clk     : in  STD_LOGIC;
           index   : in  STD_LOGIC_VECTOR(2 downto 0); -- Index for 8 entries
           tag_in  : in  STD_LOGIC_VECTOR(4 downto 0); -- Tag input
           we      : in  STD_LOGIC;                   -- Write enable
           tag_out : out STD_LOGIC_VECTOR(4 downto 0) -- Tag output
           );
end TagRAM;

architecture Behavioral of TagRAM is
    type tag_array is array (0 to 7) of STD_LOGIC_VECTOR(4 downto 0);
    signal tags : tag_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                tags(to_integer(unsigned(index))) <= tag_in;
            end if;
            tag_out <= tags(to_integer(unsigned(index)));
        end if;
    end process;
end Behavioral;

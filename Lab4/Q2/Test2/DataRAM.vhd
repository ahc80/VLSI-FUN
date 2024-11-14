library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataRAM is
    Port ( clk      : in  STD_LOGIC;
           index    : in  STD_LOGIC_VECTOR(2 downto 0); -- Index for 8 entries
           data_in  : in  STD_LOGIC_VECTOR(31 downto 0); -- Data input
           we       : in  STD_LOGIC;                   -- Write enable
           data_out : out STD_LOGIC_VECTOR(31 downto 0) -- Data output
           );
end DataRAM;

architecture Behavioral of DataRAM is
    type data_array is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal data_store : data_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                data_store(to_integer(unsigned(index))) <= data_in;
            end if;
            data_out <= data_store(to_integer(unsigned(index)));
        end if;
    end process;
end Behavioral;

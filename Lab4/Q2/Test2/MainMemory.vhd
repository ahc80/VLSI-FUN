library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MainMemory is
    Port ( addr      : in  STD_LOGIC_VECTOR(15 downto 0);
           data_in   : in  STD_LOGIC_VECTOR(31 downto 0);
           data_out  : out STD_LOGIC_VECTOR(31 downto 0);
           mem_read  : in  STD_LOGIC;
           mem_write : in  STD_LOGIC
           );
end MainMemory;

architecture Behavioral of MainMemory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin
    process
    begin
        if mem_read = '1' then
            data_out <= mem(to_integer(unsigned(addr(7 downto 0))));
        elsif mem_write = '1' then
            mem(to_integer(unsigned(addr(7 downto 0)))) <= data_in;
        end if;
    end process;
end Behavioral;

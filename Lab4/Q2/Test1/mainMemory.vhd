library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mainMemory is
    Port(
        sysRW : in bit;
        sysAddress : in std_logic_vector(15 downto 0);
        sysStrobe : in bit;
        sysDataIn : in std_logic_vector(31 downto 0);
        sysDataOut : out std_logic_vector(31 downto 0)
    );
end entity mainMemory;

architecture sim of mainMemory is
    type memType is array (16383 downto 0) of std_logic_vector(31 downto 0);
    signal mem : memType := (others => (others => '0'));

begin
    process(sysStrobe)
    begin
        if rising_edge(sysStrobe) then
            if sysRW = '1' then
                mem(to_integer(unsigned(sysAddress(15 downto 2)))) <= sysDataIn;
                sysDataOut <= sysDataIn;
            else
                sysDataOut <= mem(to_integer(unsigned(sysAddress(15 downto 2))));
            end if;
        end if;
    end process;
end architecture sim;


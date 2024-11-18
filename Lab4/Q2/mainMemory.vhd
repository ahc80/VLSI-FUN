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

architecture behavior of mainMemory is
    -- Memory declaration
    type memType is array (16383 downto 0) of std_logic_vector(31 downto 0);
    signal mem : memType := (others => (others => '0'));

begin
    process(sysStrobe)
        variable tempDataOut : std_logic_vector(31 downto 0); -- Temporary data for output
    begin
        if rising_edge(sysStrobe) then
            if sysRW = '1' then
                -- Write operation
                mem(to_integer(unsigned(sysAddress(15 downto 2)))) <= sysDataIn;
                tempDataOut := sysDataIn; -- Store input data for output
            else
                -- Read operation
                tempDataOut := mem(to_integer(unsigned(sysAddress(15 downto 2))));
            end if;
            sysDataOut <= tempDataOut; -- Assign output after operation
        end if;
    end process;
end architecture behavior;

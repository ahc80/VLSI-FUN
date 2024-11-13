library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    Port(
        sysAddress : in  std_logic_vector(15 downto 0);     -- Address from cache (16 bits)
        sysDataIn  : in  std_logic_vector(31 downto 0);     -- Data input for write operations
        sysRW      : in  std_logic;                         -- Read (0) or Write (1) control
        sysStrobe  : in  std_logic;                         -- Strobe to initiate memory operation
        sysDataOut : out std_logic_vector(31 downto 0)      -- Data output for read operations
    );
end memory;

architecture Behavioral of memory is
    -- Define a memory array with 16K 32-bit words (4 bytes each)
    type mem_array is array (0 to 16383) of std_logic_vector(31 downto 0);
    signal mem : mem_array;  -- Memory storage

    -- Define parameters for memory initialization
    constant INIT_VALUES : mem_array := (
        16#10#: x"AABBCCDD",
        16#20#: x"11223344",
        16#31#: x"99881133",
        16#80#: x"ABCDEF01",
        16#51#: x"12345678",
        16#57#: x"6789ABCD",
        16#58#: x"A1B2C3D4",
        16#59#: x"9A8B1C3D",
        others => (others => '0')
    );

begin
    -- Initialize memory with predefined values for testing
    mem <= INIT_VALUES;

    -- Process triggered by the strobe signal to handle memory operations
    process(sysStrobe)
    begin
        if rising_edge(sysStrobe) then
            if sysRW = '1' then  -- Write operation
                mem(to_integer(unsigned(sysAddress(15 downto 2)))) <= sysDataIn;
                sysDataOut <= sysDataIn;  -- Output the data being written
            else  -- Read operation
                sysDataOut <= mem(to_integer(unsigned(sysAddress(15 downto 2))));
            end if;
        end if;
    end process;

end Behavioral;

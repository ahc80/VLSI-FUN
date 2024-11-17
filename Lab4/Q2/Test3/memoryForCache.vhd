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
    signal mem : mem_array := (others => (others => '0'));  -- Initialize memory to zero

    -- Memory operation control signals
    signal wait_counter : integer := 0;

begin
    -- Initialization process to preload specific addresses
    process
    begin
        mem(16#10#) <= x"AABBCCDD";
        mem(16#20#) <= x"11223344";
        mem(16#31#) <= x"99881133";
        mem(16#80#) <= x"ABCDEF01";
        mem(16#51#) <= x"12345678";
        mem(16#57#) <= x"6789ABCD";
        mem(16#58#) <= x"A1B2C3D4";
        mem(16#59#) <= x"9A8B1C3D";
        wait;  -- This process runs only once at simulation start
    end process;

    -- Process for handling memory operations with wait states
    process(sysStrobe, sysRW)
    begin
        if rising_edge(sysStrobe) then
            wait_counter <= 4;  -- Set a 4-cycle wait state
        end if;

        if wait_counter > 0 then
            wait_counter <= wait_counter - 1;
        elsif wait_counter = 0 then
            if sysRW = '1' then  -- Write operation
                case sysAddress(1 downto 0) is
                    when "00" => mem(to_integer(unsigned(sysAddress(15 downto 2))))(7 downto 0) <= sysDataIn(7 downto 0);
                    when "01" => mem(to_integer(unsigned(sysAddress(15 downto 2))))(15 downto 8) <= sysDataIn(15 downto 8);
                    when "10" => mem(to_integer(unsigned(sysAddress(15 downto 2))))(23 downto 16) <= sysDataIn(23 downto 16);
                    when "11" => mem(to_integer(unsigned(sysAddress(15 downto 2))))(31 downto 24) <= sysDataIn(31 downto 24);
                    when others => null;
                end case;
                sysDataOut <= sysDataIn;  -- Output written data

            else  -- Read operation
                case sysAddress(1 downto 0) is
                    when "00" => sysDataOut <= x"000000" & mem(to_integer(unsigned(sysAddress(15 downto 2))))(7 downto 0);
                    when "01" => sysDataOut <= x"000000" & mem(to_integer(unsigned(sysAddress(15 downto 2))))(15 downto 8);
                    when "10" => sysDataOut <= x"000000" & mem(to_integer(unsigned(sysAddress(15 downto 2))))(23 downto 16);
                    when "11" => sysDataOut <= x"000000" & mem(to_integer(unsigned(sysAddress(15 downto 2))))(31 downto 24);
                    when others => sysDataOut <= (others => '0');
                end case;
            end if;
        end if;
    end process;

end Behavioral;


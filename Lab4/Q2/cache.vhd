library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache is
    Port(
        clk         : in  std_logic;
        pstrobe     : in  std_logic;  -- Signal to indicate a read/write request
        prw         : in  std_logic;  -- Read (0) or Write (1) control
        paddress    : in  std_logic_vector(15 downto 0);  -- Processor address
        pdata_in    : in  std_logic_vector(31 downto 0);  -- Processor data input
        pdata_out   : out std_logic_vector(31 downto 0);  -- Processor data output
        pready      : out std_logic   -- Ready signal indicating operation completion
    );
end cache;

architecture Behavioral of cache is
    -- Define cache, tag, and dirty bit arrays with 256 entries (8-bit index)
    type cache_array is array (255 downto 0) of std_logic_vector(31 downto 0);
    type tag_array is array (255 downto 0) of std_logic_vector(5 downto 0);  -- 6-bit tag
    type dirty_array is array (255 downto 0) of std_logic;

    signal cache_ram : cache_array;  -- Data storage for cache lines
    signal tag_ram   : tag_array;    -- Tag storage for each cache line
    signal dirty_bit : dirty_array;  -- Dirty bit to indicate modified lines

    -- Memory interface signals for handling cache misses
    component memory
        Port(
            sysAddress : in  std_logic_vector(15 downto 0);
            sysDataIn  : in  std_logic_vector(31 downto 0);
            sysRW      : in  std_logic;
            sysStrobe  : in  std_logic;
            sysDataOut : out std_logic_vector(31 downto 0)
        );
    end component;

    signal sysDataOut : std_logic_vector(31 downto 0);  -- Data received from memory on a miss
    signal cache_hit  : std_logic;  -- Cache hit flag

    -- Address breakdown
    signal index : integer range 0 to 255;  -- Extracted index (8 bits) from paddress
    signal tag   : std_logic_vector(5 downto 0);  -- Extracted tag (6 bits) from paddress

begin

    -- Memory component instantiation
    mem_inst : memory
        port map(
            sysAddress => paddress,
            sysDataIn  => pdata_in,
            sysRW      => prw,
            sysStrobe  => pstrobe,
            sysDataOut => sysDataOut
        );

    -- Process to handle cache read/write operations with dirty bit
    process(clk)
    begin
        if rising_edge(clk) then
            if pstrobe = '1' then
                index <= to_integer(unsigned(paddress(9 downto 2)));  -- Extract index from address
                tag   <= paddress(15 downto 10);  -- Extract tag from address
                
                if prw = '1' then  -- Write operation
                    cache_ram(index) <= pdata_in;
                    tag_ram(index)   <= tag;
                    dirty_bit(index) <= '1';  -- Mark line as dirty
                    pready <= '1';
                else  -- Read operation
                    -- Check if the cache line is valid by comparing tags
                    if tag_ram(index) = tag and dirty_bit(index) = '1' then
                        pdata_out <= cache_ram(index);  -- Cache hit
                        cache_hit <= '1';
                    else
                        -- On cache miss, read from memory and update cache
                        cache_ram(index) <= sysDataOut;
                        tag_ram(index)   <= tag;
                        dirty_bit(index) <= '1';  -- Mark as updated
                        pdata_out <= sysDataOut;
                        cache_hit <= '0';
                    end if;
                    pready <= '1';
                end if;
            else
                pready <= '0';  -- Not ready when no strobe
            end if;
        end if;
    end process;

end Behavioral;

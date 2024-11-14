library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CacheController is
    Port ( clk          : in  STD_LOGIC;
           addr         : in  STD_LOGIC_VECTOR(15 downto 0);
           data_in      : in  STD_LOGIC_VECTOR(31 downto 0);
           data_out     : out STD_LOGIC_VECTOR(31 downto 0);
           mem_read     : out STD_LOGIC;
           mem_write    : out STD_LOGIC;
           cache_hit    : out STD_LOGIC;
           we           : out STD_LOGIC -- Write enable for Data and Tag RAMs
           );
end CacheController;

architecture Behavioral of CacheController is
    signal tag        : STD_LOGIC_VECTOR(4 downto 0);
    signal index      : STD_LOGIC_VECTOR(2 downto 0);
    signal byte       : STD_LOGIC_VECTOR(1 downto 0);
    signal tag_ram_out : STD_LOGIC_VECTOR(4 downto 0);
    signal data_ram_out: STD_LOGIC_VECTOR(31 downto 0);

    -- Instantiate TagRAM and DataRAM here
    component TagRAM
        Port ( clk     : in  STD_LOGIC;
               index   : in  STD_LOGIC_VECTOR(2 downto 0);
               tag_in  : in  STD_LOGIC_VECTOR(4 downto 0);
               we      : in  STD_LOGIC;
               tag_out : out STD_LOGIC_VECTOR(4 downto 0)
               );
    end component;

    component DataRAM
        Port ( clk      : in  STD_LOGIC;
               index    : in  STD_LOGIC_VECTOR(2 downto 0);
               data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
               we       : in  STD_LOGIC;
               data_out : out STD_LOGIC_VECTOR(31 downto 0)
               );
    end component;

begin
    -- Split address into tag, index, and byte fields
    tag   <= addr(15 downto 10);
    index <= addr(9 downto 7);
    byte  <= addr(1 downto 0);

    -- Instantiate TagRAM
    TagRAM_inst : TagRAM
        Port map ( clk => clk,
                   index => index,
                   tag_in => tag,
                   we => we,
                   tag_out => tag_ram_out );

    -- Instantiate DataRAM
    DataRAM_inst : DataRAM
        Port map ( clk => clk,
                   index => index,
                   data_in => data_in,
                   we => we,
                   data_out => data_ram_out );

    -- Cache hit/miss logic
    cache_hit <= '1' when (tag_ram_out = tag) else '0';
    we <= '1' when cache_hit = '0' else '0'; -- Write only on cache miss

    -- Read/Write Control Logic
    mem_read  <= '1' when (cache_hit = '0') else '0';
    mem_write <= '0'; -- Write-through logic can be added

    -- Connect to DataRAM output
    data_out <= data_ram_out;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CacheSystem is
    Port ( clk      : in  STD_LOGIC;
           addr     : in  STD_LOGIC_VECTOR(15 downto 0);
           data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
           data_out : out STD_LOGIC_VECTOR(31 downto 0);
           read     : in  STD_LOGIC;
           write    : in  STD_LOGIC
           );
end CacheSystem;

architecture Behavioral of CacheSystem is
    component CacheController
        Port ( clk          : in  STD_LOGIC;
               addr         : in  STD_LOGIC_VECTOR(15 downto 0);
               data_in      : in  STD_LOGIC_VECTOR(31 downto 0);
               data_out     : out STD_LOGIC_VECTOR(31 downto 0);
               mem_read     : out STD_LOGIC;
               mem_write    : out STD_LOGIC;
               cache_hit    : out STD_LOGIC;
               we           : out STD_LOGIC
               );
    end component;

    component MainMemory
        Port ( addr      : in  STD_LOGIC_VECTOR(15 downto 0);
               data_in   : in  STD_LOGIC_VECTOR(31 downto 0);
               data_out  : out STD_LOGIC_VECTOR(31 downto 0);
               mem_read  : in  STD_LOGIC;
               mem_write : in  STD_LOGIC
               );
    end component;

    signal mem_read, mem_write : STD_LOGIC;
    signal cache_hit           : STD_LOGIC;
    signal we                  : STD_LOGIC;

begin
    -- Instantiate CacheController
    CacheController_inst : CacheController
        Port map ( clk => clk,
                   addr => addr,
                   data_in => data_in,
                   data_out => data_out,
                   mem_read => mem_read,
                   mem_write => mem_write,
                   cache_hit => cache_hit,
                   we => we );

    -- Instantiate MainMemory
    MainMemory_inst : MainMemory
        Port map ( addr => addr,
                   data_in => data_in,
                   data_out => data_out,
                   mem_read => mem_read,
                   mem_write => mem_write );
end Behavioral;

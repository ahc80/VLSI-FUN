library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cacheTB is
end entity;

architecture sim of cacheTB is
    -- Component declaration for CacheSystem
    component CacheSystem is
        Port (
            clk       : in  std_logic;
            addr      : in  std_logic_vector(15 downto 0);
            data_in   : in  std_logic_vector(31 downto 0);
            data_out  : out std_logic_vector(31 downto 0);
            read      : in  std_logic;
            write     : in  std_logic
        );
    end component;

    -- Signals to interface with CacheSystem
    signal clk       : std_logic := '0';
    signal addr      : std_logic_vector(15 downto 0);
    signal data_in   : std_logic_vector(31 downto 0);
    signal data_out  : std_logic_vector(31 downto 0);
    signal read      : std_logic;
    signal write     : std_logic;

    -- Clock generation process
    constant CLOCK_PERIOD : time := 100 ns;

begin
    -- Instantiate the CacheSystem component
    cache_system_instance : CacheSystem
        port map (
            clk       => clk,
            addr      => addr,
            data_in   => data_in,
            data_out  => data_out,
            read      => read,
            write     => write
        );

    -- Clock process to generate a 100 ns clock period
    clk_process : process
    begin
        clk <= '0';
        wait for CLOCK_PERIOD / 2;
        clk <= '1';
        wait for CLOCK_PERIOD / 2;
    end process clk_process;

    -- Test process
    stimulus : process
    begin
        -- Write operations to cache and main memory
        -- Write to address 0x0012 with data 0xAAAAAAAA
        addr <= x"0012";
        data_in <= x"AAAAAAAA";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;
        
        -- Write to address 0x0045 with data 0xBBBBBBBB
        addr <= x"0045";
        data_in <= x"BBBBBBBB";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;
        
        -- Write to address 0x0076 with data 0xCCCCCCCC
        addr <= x"0076";
        data_in <= x"CCCCCCCC";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;
        
        -- Write to address 0x0066 with data 0xDDDDDDDD
        addr <= x"0066";
        data_in <= x"DDDDDDDD";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;
        
        -- Write to address 0x0076 again with data 0xEEEEEEEE (to test cache coherence)
        addr <= x"0076";
        data_in <= x"EEEEEEEE";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;

        -- Write to address 0x0059 with data 0xFFFFFFFF
        addr <= x"0059";
        data_in <= x"FFFFFFFF";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;

        -- Write to address 0x0045 again with data 0x11111111 (to test cache coherence)
        addr <= x"0045";
        data_in <= x"11111111";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;

        -- Write to address 0x0012 again with data 0x22222222 (to test cache coherence)
        addr <= x"0012";
        data_in <= x"22222222";
        write <= '1';
        read <= '0';
        wait for CLOCK_PERIOD;
        write <= '0';
        wait for 10 ns;

        -- Read operations from cache
        -- Read from address 0x0012
        addr <= x"0012";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;
        
        -- Read from address 0x0045
        addr <= x"0045";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;
        
        -- Read from address 0x0076
        addr <= x"0076";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;

        -- Read from address 0x0066
        addr <= x"0066";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;
        
        -- Read from address 0x0076 again (should hit cache if caching was effective)
        addr <= x"0076";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;
        
        -- Read from address 0x0059
        addr <= x"0059";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;

        -- Read from address 0x0045 again (should hit cache if caching was effective)
        addr <= x"0045";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;

        -- Read from address 0x0012 again (should hit cache if caching was effective)
        addr <= x"0012";
        write <= '0';
        read <= '1';
        wait for CLOCK_PERIOD;
        read <= '0';
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process stimulus;
end architecture sim;

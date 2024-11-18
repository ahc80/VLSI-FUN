library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cacheTB is
end entity cacheTB;

architecture sim of cacheTB is
    component cacheMemory is
        Port(
            pStrobe : in bit;
            pAddress : in std_logic_vector(15 downto 0);
            pRW : in bit;
            pDataIn : in std_logic_vector(31 downto 0);
            pDataOut : out std_logic_vector(31 downto 0);
            pReady : out bit;
            clk : in bit
        );
    end component;

    signal pRW, pStrobe, pReady : bit := '0';
    signal clk : bit := '0';
    signal pAddress : std_logic_vector(15 downto 0) := (others => '0');
    signal pDataIn, pDataOut : std_logic_vector(31 downto 0) := (others => '0');

begin
    cm : cacheMemory
        port map(pStrobe, pAddress, pRW, pDataIn, pDataOut, pReady, clk);

    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    test_process: process
        variable cache_hit : string(1 to 4);
    begin
        -- Starting test
        report "*****************Starting Cache Test*****************" severity note;

        -- Access Address 0x0012
        pRW <= '0';  -- Read operation
        pAddress <= x"0012";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0012. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0045
        pAddress <= x"0045";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0045. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0076
        pAddress <= x"0076";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0076. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0066
        pAddress <= x"0066";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0066. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0076 (again)
        pAddress <= x"0076";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0076. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0059
        pAddress <= x"0059";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0059. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0045 (again)
        pAddress <= x"0045";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0045. Cache " & cache_hit severity note;

        wait for 20 ns;

        -- Access Address 0x0012 (again)
        pAddress <= x"0012";
        pStrobe <= '1';
        wait for 10 ns;
        pStrobe <= '0';
        if pReady = '1' then
            cache_hit := "HIT!";
        else
            cache_hit := "MISS";
        end if;
        report "Accessing Address: 0x0012. Cache " & cache_hit severity note;

        -- Ending test
        report "*****************Ending Cache Test*****************" severity note;
	wait; 
    end process;
end architecture sim;

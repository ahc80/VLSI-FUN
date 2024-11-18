library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cacheMemory is
    Port(
        pStrobe : in bit;
        pAddress : in std_logic_vector(15 downto 0);
        pRW : in bit;
        pDataIn : in std_logic_vector(31 downto 0);
        pDataOut : out std_logic_vector(31 downto 0);
        pReady : out bit;
        clk : in bit
    );
end entity cacheMemory;

architecture sim of cacheMemory is
    component mainMemory is
        Port(
            sysRW : in bit;
            sysAddress : in std_logic_vector(15 downto 0);
            sysStrobe : in bit;
            sysDataIn : in std_logic_vector(31 downto 0);
            sysDataOut : out std_logic_vector(31 downto 0)
        );
    end component;

    type cacheType is array (255 downto 0) of std_logic_vector(31 downto 0);
    type tagType is array (255 downto 0) of std_logic_vector(5 downto 0);
    type dirtyType is array (255 downto 0) of bit;

    signal cache : cacheType := (others => (others => '0'));
    signal tag : tagType := (others => (others => '0'));
    signal dirtyBit : dirtyType := (others => '0');
    signal sysRW, sysStrobe: bit := '0';
    signal sysAddress : std_logic_vector(15 downto 0) := (others => '0');
    signal sysDataIn, sysDataOut : std_logic_vector(31 downto 0) := (others => '0');

begin
    mm : mainMemory
        port map(sysRW, sysAddress, sysStrobe, sysDataIn, sysDataOut);

    process(clk)
        variable index : integer;
    begin
        if rising_edge(clk) then
            -- Calculate the cache index for readability
            index := to_integer(unsigned(pAddress(9 downto 2)));

            -- If Strobe is Enabled, Handle Cache Operations
            if pStrobe = '1' then
                if pRW = '1' then
                    -- Write Operation
                    report "Writing to Cache.";

                    dirtyBit(index) <= '1';
                    tag(index) <= pAddress(15 downto 10);
                    cache(index) <= pDataIn;
                    pReady <= '0';

                    -- Forward to Main Memory
                    sysRW <= '1';
                    sysAddress <= pAddress;
                    sysDataIn <= pDataIn;
                    sysStrobe <= '1';
                else
                    -- Read Operation
                    if tag(index) = pAddress(15 downto 10) and dirtyBit(index) = '1' then
                        -- Cache Hit
                        report "Cache HIT!";

                        pDataOut <= cache(index);
                        pReady <= '1';
                    else
                        -- Cache Miss
                        report "Cache MISS!";

                        -- Fetch Data from Main Memory
                        pReady <= '0';
                        sysAddress <= pAddress;
                        sysStrobe <= '1';

                        -- Update Cache on Miss
                        tag(index) <= pAddress(15 downto 10);
                        cache(index) <= sysDataOut;
                        dirtyBit(index) <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture sim;

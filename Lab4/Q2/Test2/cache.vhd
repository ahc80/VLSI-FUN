-- Cache.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cache is
    Port (
        clk : in STD_LOGIC;
        -- Processor signals
        Pstrobe : in STD_LOGIC;
        Prw : in STD_LOGIC;  -- '1' for read, '0' for write
        Paddress : in STD_LOGIC_VECTOR(15 downto 0);
        Pdata : inout STD_LOGIC_VECTOR(31 downto 0);
        Pready : out STD_LOGIC;
        -- System bus signals
        Sysstrobe : out STD_LOGIC;
        Sysrw : out STD_LOGIC;
        Sysaddress : out STD_LOGIC_VECTOR(15 downto 0);
        Sysdata : inout STD_LOGIC_VECTOR(31 downto 0)
    );
end Cache;

architecture Behavioral of Cache is

    type CacheRAM is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    type TagRAM is array (0 to 7) of STD_LOGIC_VECTOR(5 downto 0);

    signal cache_ram : CacheRAM := (others => (others => '0'));
    signal tag_ram : TagRAM := (others => (others => '0'));
    signal valid : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal index : INTEGER range 0 to 7;
    signal tag : STD_LOGIC_VECTOR(5 downto 0);
    signal byte_offset : STD_LOGIC_VECTOR(1 downto 0);

    signal Pdata_out : STD_LOGIC_VECTOR(31 downto 0);
    signal Pdata_en : STD_LOGIC;

    signal state : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Simple FSM: 00=Idle, 01=Wait, 10=MemRead

begin

    -- Tri-state data bus handling
    Pdata <= Pdata_out when Pdata_en = '1' else (others => 'Z');
    Sysdata <= (others => 'Z'); -- Assuming sysdata is connected elsewhere

    process(clk)
    begin
        if rising_edge(clk) then
            if Pstrobe = '1' then
                -- Extract address fields
                tag <= Paddress(15 downto 10);
                index <= to_integer(unsigned(Paddress(9 downto 2)));
                byte_offset <= Paddress(1 downto 0);

                if Prw = '1' then  -- Read operation
                    if valid(index) = '1' and tag_ram(index) = tag then
                        -- Cache hit
                        Pdata_out <= cache_ram(index);
                        Pdata_en <= '1';
                        Pready <= '1';
                    else
                        -- Cache miss, initiate memory read
                        Sysstrobe <= '1';
                        Sysrw <= '1'; -- Read operation
                        Sysaddress <= Paddress;
                        state <= "10"; -- Transition to MemRead state
                        Pready <= '0';
                    end if;
                else  -- Write operation (write-through)
                    cache_ram(index) <= Pdata;
                    tag_ram(index) <= tag;
                    valid(index) <= '1';

                    -- Initiate write to memory
                    Sysstrobe <= '1';
                    Sysrw <= '0'; -- Write operation
                    Sysaddress <= Paddress;
                    Sysdata <= Pdata;
                    Pready <= '1';
                end if;
            else
                Pdata_en <= '0';
                Pready <= '0';
                Sysstrobe <= '0';
            end if;

            -- State machine for memory read during cache miss
            if state = "10" then
                -- Simulate memory latency
                -- Assuming one clock cycle delay for memory read
                cache_ram(index) <= Sysdata; -- Assume Sysdata has the data after one cycle
                tag_ram(index) <= tag;
                valid(index) <= '1';
                Pdata_out <= Sysdata;
                Pdata_en <= '1';
                Pready <= '1';
                Sysstrobe <= '0';
                state <= "00"; -- Return to Idle state
            end if;
        end if;
    end process;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
    port (
        clk       : in  std_logic;  -- Clock signal
        rst_n     : in  std_logic;  -- Active-low reset signal
        enable    : in  std_logic;  -- Enable signal for shifting
        data_in   : in  std_logic;  -- Serial input data (single bit)
        data_out  : out std_logic   -- Serial output data (single bit)
    );
end shift_register;

architecture rtl of shift_register is
    signal stage : std_logic_vector(3 downto 0); -- 4-bit internal shift register
begin

    -- Assign the last bit of the shift register as the serial output
    data_out <= stage(3);

    -- Shift register process
    shift_reg_process : process(clk, rst_n)
    begin
        if (rst_n = '0') then
            -- Clear all stages to zero on reset
            stage <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                -- Shift data through the register
                stage <= data_in & stage(3 downto 1); -- Shift right, inserting data_in at the LSB
            end if;
        end if;
    end process shift_reg_process;

end rtl;

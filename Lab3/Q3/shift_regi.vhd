library ieee;
use ieee.std._logic_1164.all;

entity shift_register is
    port (
        clk          : in  std_logic;                    -- Clock signal
        rst_n        : in  std_logic;                    -- Active-low reset signal (renamed from i_rstb)
        data_in      : in  std_logic_vector(7 downto 0); -- 8-bit input data (renamed from i_data)
        data_out     : out std_logic_vector(7 downto 0)  -- 8-bit output data (renamed from o_data)
    );
end shift_register;

architecture rtl of shift_register is
    signal stage0_reg : std_logic_vector(7 downto 0);    -- Stage 0 register (renamed from r0_data)
    signal stage1_reg : std_logic_vector(7 downto 0);    -- Stage 1 register (renamed from r1_data)
    signal stage2_reg : std_logic_vector(7 downto 0);    -- Stage 2 register (renamed from r2_data)
    signal stage3_reg : std_logic_vector(7 downto 0);    -- Stage 3 register (renamed from r3_data)

begin

    -- The final output comes from the last stage
    data_out <= stage3_reg;

    -- Shift register process
    shift_reg_process : process(clk, rst_n)
    begin
        if (rst_n = '0') then
            -- Active-low reset: clear all stages to zero
            stage0_reg <= (others => '0');
            stage1_reg <= (others => '0');
            stage2_reg <= (others => '0');
            stage3_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- Shift data through the stages
            stage0_reg <= data_in;       -- Load input data into Stage 0
            stage1_reg <= stage0_reg;    -- Shift Stage 0 data to Stage 1
            stage2_reg <= stage1_reg;    -- Shift Stage 1 data to Stage 2
            stage3_reg <= stage2_reg;    -- Shift Stage 2 data to Stage 3
        end if;
    end process shift_reg_process;

end rtl;

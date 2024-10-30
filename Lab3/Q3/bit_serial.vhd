library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_bit_adder is
    Port (
        clk         : in STD_LOGIC;
        reset       : in STD_LOGIC;
        load        : in STD_LOGIC; -- Signal to load inputs
        A           : in STD_LOGIC_VECTOR (7 downto 0); -- Input operand A
        B           : in STD_LOGIC_VECTOR (7 downto 0); -- Input operand B
        result      : out STD_LOGIC_VECTOR (7 downto 0); -- Output sum
        carry_out   : out STD_LOGIC -- Final carry out
    );
end entity serial_bit_adder;

architecture Behavioral of serial_bit_adder is
    signal addend, augend         : STD_LOGIC_VECTOR (7 downto 0); -- Shift registers for A and B
    signal result_internal        : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); -- Intermediate sum storage
    signal carry                  : STD_LOGIC := '0'; -- Carry bit
    signal counter                : INTEGER range 0 to 8 := 0; -- Bit position counter

begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all internal states
            result_internal <= (others => '0');
            carry <= '0';
            counter <= 0;
            addend <= (others => '0');
            augend <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                -- Load the inputs A and B into shift registers addend and augend
                addend <= A;
                augend <= B;
                carry <= '0';
                counter <= 0;
                result_internal <= (others => '0');
            elsif counter < 8 then
                -- Perform serial addition for each bit --> This is the Full Adder
                result_internal(counter) <= addend(0) XOR augend(0) XOR carry;
                carry <= (addend(0) AND augend(0)) OR (addend(0) AND carry) OR (augend(0) AND carry);

                -- Shift right for the next bit operation
                addend <= '0' & addend(7 downto 1);
                augend <= '0' & augend(7 downto 1);
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Assign output signals
    result <= result_internal;
    carry_out <= carry;

end Behavioral;

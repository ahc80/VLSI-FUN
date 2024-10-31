library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_bit_adder is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        load        : in  STD_LOGIC; -- Signal to load inputs
        A           : in  STD_LOGIC_VECTOR (7 downto 0); -- Input operand A
        B           : in  STD_LOGIC_VECTOR (7 downto 0); -- Input operand B
        result      : out STD_LOGIC_VECTOR (7 downto 0); -- Output sum
        carry_out   : out STD_LOGIC -- Final carry out
    );
end entity serial_bit_adder;

architecture Behavioral of serial_bit_adder is

    -- Declare components
    component FullAdder
        Port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    component ShiftRegister
        Port (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            load       : in  STD_LOGIC;
            data_in    : in  STD_LOGIC_VECTOR (7 downto 0);
            shift_out  : out STD_LOGIC;
            shift_reg  : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Internal signals
    signal addend, augend         : STD_LOGIC_VECTOR (7 downto 0);
    signal result_internal        : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal carry                  : STD_LOGIC := '0';
    signal counter                : INTEGER range 0 to 8 := 0;
    signal sum_bit, carry_bit     : STD_LOGIC;
    signal addend_bit, augend_bit : STD_LOGIC;

begin

    -- Instantiate the Shift Register for Addend
    AddendShiftRegister: ShiftRegister
        Port map (
            clk      => clk,
            reset    => reset,
            load     => load,
            data_in  => A,
            shift_out => addend_bit,
            shift_reg => addend
        );

    -- Instantiate the Shift Register for Augend
    AugendShiftRegister: ShiftRegister
        Port map (
            clk      => clk,
            reset    => reset,
            load     => load,
            data_in  => B,
            shift_out => augend_bit,
            shift_reg => augend
        );

    -- Instantiate the Full Adder
    FullAdderInst: FullAdder
        Port map (
            A    => addend_bit,
            B    => augend_bit,
            Cin  => carry,
            Sum  => sum_bit,
            Cout => carry_bit
        );

    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all internal states
            result_internal <= (others => '0');
            carry <= '0';
            counter <= 0;
        elsif rising_edge(clk) then
            if load = '1' then
                -- Load the inputs and reset carry and counter
                carry <= '0';
                counter <= 0;
                result_internal <= (others => '0');
            elsif counter < 8 then
                -- Use full adder output for each bit's sum and carry
                result_internal(counter) <= sum_bit;
                carry <= carry_bit;
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Assign output signals
    result <= result_internal;
    carry_out <= carry;

end Behavioral;

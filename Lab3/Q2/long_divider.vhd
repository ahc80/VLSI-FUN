library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity long_divider is
    Port (
        M : in std_logic_vector(3 downto 0);          -- Divisor
        D : in std_logic_vector(6 downto 0);          -- Dividend
        Q : out std_logic_vector(3 downto 0);         -- Quotient
        R : out std_logic_vector(3 downto 0);         -- Remainder
        debug_cas_array_sum : out std_logic_vector(4 downto 0);  -- Debug output for cas_array_sum
        debug_Q_wire        : out std_logic_vector(3 downto 0)   -- Debug output for Q_wire
    );
end long_divider;

architecture Behavioral of long_divider is
    -- Define a 2D array type for cas_array_sum
    type array_2d is array (0 to 3) of std_logic_vector(4 downto 0);
    signal cas_array_sum : array_2d := (others => (others => '0'));
    signal Q_wire        : std_logic_vector(3 downto 0) := (others => '0');
begin
    -- Assign debug outputs
    debug_cas_array_sum <= cas_array_sum(0); -- Expose only the first row for debugging; adjust as needed
    debug_Q_wire <= Q_wire;

    -- Assign initial values to the first row of cas_array_sum
    cas_array_sum(0)(0) <= D(2);
    cas_array_sum(0)(1) <= D(1);
    cas_array_sum(0)(2) <= D(0);

    -- Instantiate the first four_CAS_array
    cas0: entity work.four_CAS_array
        port map (
            M => M,
            A => D(6 downto 3),  -- This is a 4-bit slice
            B => '1',
            Q => Q_wire(3),
            S => cas_array_sum(0)(4 downto 1)  -- Connect to the first row
        );

    -- Generate remaining four_CAS_arrays
    gen_cas: for i in 1 to 3 generate
        cas123: entity work.four_CAS_array
            port map (
                M => M,  -- Pass the entire 4-bit vector M
                A => cas_array_sum(i-1)(3 downto 0),  -- Connect to the previous row
                B => Q_wire(4-i),
                Q => Q_wire(3-i),
                S => cas_array_sum(i)(4 downto 1)  -- Connect to the current row
            );
    end generate;

    -- Instantiate remainder correction block
    rc0: entity work.four_RC_array
        port map (
            A => cas_array_sum(3)(4 downto 1),  -- Connect to the last row of cas_array_sum
            M => M,
            R => R
        );

    -- Assign the quotient output
    Q(0) <= Q_wire(0);
    Q(1) <= Q_wire(1);
    Q(2) <= Q_wire(2);
    Q(3) <= Q_wire(3);

end Behavioral;

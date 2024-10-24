library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arth.all;
use ieee.std_logic_unsigned.all;

entity long_divider is
    Port (
        M : in std_logic_vector(3 downto 0);  -- Divisor
        D : in std_logic_vector(6 downto 0);  -- Dividend
        Q : out std_logic_vector(3 downto 0); -- Quotient
        R : out std_logic_vector(3 downto 0)  -- Remainder
    );
end long_divider;

architecture Behavioral of long_divider is
    signal cas_array_sum : std_logic_vector(4 downto 0) := (others => '0');
    signal Q_wire        : std_logic_vector(3 downto 0) := (others => '0');
begin
    -- Assign initial values
    cas_array_sum(0) <= D(2);
    cas_array_sum(1) <= D(1);
    cas_array_sum(2) <= D(0);

    -- Instantiate the first four_CAS_array
    cas0: entity work.four_CAS_array
        port map (
            M => M,
            A => D(6 downto 3),
            B => '1',
            Q => Q_wire(3),
            S => cas_array_sum(4 downto 1)
        );

    -- Generate the remaining four_CAS_arrays
    gen_cas: for i in 1 to 3 generate
        cas123: entity work.four_CAS_array
            port map (
                M => M,
                A => cas_array_sum(i-1 downto 0),
                B => Q_wire(4-i),
                Q => Q_wire(3-i),
                S => cas_array_sum(i downto 1)
            );
    end generate;

    -- Instantiate the remainder correction
    rc0: entity work.four_RC_array
        port map (
            A => cas_array_sum(3 downto 1),
            M => M,
            R => R
        );

    -- Assign the quotient
    Q <= Q_wire;
end Behavioral;

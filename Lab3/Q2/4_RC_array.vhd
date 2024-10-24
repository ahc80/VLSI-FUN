library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arth.all;
use ieee.std_logic_unsigned.all;

entity four_RC_array is
    Port (
        A : in std_logic_vector(3 downto 0);
        M : in std_logic_vector(3 downto 0);
        R : out std_logic_vector(3 downto 0)
    );
end four_RC_array;

architecture Behavioral of four_RC_array is
    signal C_out_wire : std_logic_vector(3 downto 0);
begin
    -- Instantiate the first remainder_correction
    RC0: entity work.remainder_correction
        port map (
            A => A(0),
            Q_bit => M(0),
            Anded_with_Q => A(3),
            C_in => '0',
            C_out => C_out_wire(0),
            R => R(0)
        );

    -- Generate the remaining remainder_corrections
    gen_rc: for i in 1 to 3 generate
        RC_inst: entity work.remainder_correction
            port map (
                A => A(i),
                Q_bit => M(i),
                Anded_with_Q => A(3),
                C_in => C_out_wire(i-1),
                C_out => C_out_wire(i),
                R => R(i)
            );
    end generate;
end Behavioral;

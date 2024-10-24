library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arth.all;
use ieee.std_logic_unsigned.all;

entity four_CAS_array is
    Port (
        M : in std_logic_vector(3 downto 0);
        A : in std_logic_vector(3 downto 0);
        B : in std_logic;

        Q : out std_logic;
        S : out std_logic_vector(3 downto 0)
    );
end four_CAS_array;

architecture Behavioral of four_CAS_array is
    signal C_out_wire : std_logic_vector(3 downto 0);
begin
    -- Instantiate the first controlled_adder_substractor
    cas0: entity work.controlled_adder_substractor
        port map (
            A => A(0),
            B => B,
            Diagonal => M(0),
            C_in => B,
            C_out => C_out_wire(0),
            S => S(0)
        );

    -- Generate the remaining controlled_adder_substractors
    gen_cas: for i in 1 to 3 generate
        cas_inst: entity work.controlled_adder_substractor
            port map (
                A => A(i),
                B => B,
                Diagonal => M(i),
                C_in => C_out_wire(i-1),
                C_out => C_out_wire(i),
                S => S(i)
            );
    end generate;

    -- Assign Q as the MSB of C_out_wire
    Q <= C_out_wire(3);
end Behavioral;

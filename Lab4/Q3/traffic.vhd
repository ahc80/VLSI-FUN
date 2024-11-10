library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLightController is
    Port (
        clk, reset, Sa, Sb : in STD_LOGIC;
        Ga, Ya, Ra, Gb, Yb, Rb : out STD_LOGIC
    );
end TrafficLightController;

architecture Behavioral of TrafficLightController is
    -- State encoding as a type
    type State_Type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12);
    signal CurrentState, NextState : State_Type;

    -- Counter for holding states
    signal counter : INTEGER := 0;

begin

    -- State transition process (synchronous with reset)
    process (clk, reset)
    begin
        if reset = '1' then
            CurrentState <= S0;
            counter <= 0;
        elsif rising_edge(clk) then
            if counter = 5 then  -- Hold for 6 cycles (0 to 5)
                CurrentState <= NextState;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- State machine logic (explicit combinational logic for state transitions and outputs)
    process (CurrentState, Sa, Sb)
    begin
        -- Default outputs (all lights off initially)
        Ga <= '0';
        Ya <= '0';
        Ra <= '0';
        Gb <= '0';
        Yb <= '0';
        Rb <= '0';

        -- Explicit state-by-state output and transition logic
        case CurrentState is
            when S0 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                NextState <= S1;

            when S1 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                NextState <= S2;

            when S2 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                NextState <= S3;

            when S3 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                NextState <= S4;

            when S4 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                NextState <= S5;

            when S5 =>
                Ga <= '1'; Ra <= '0'; Gb <= '0'; Rb <= '1';
                if Sb = '1' then
                    NextState <= S6;
                else
                    NextState <= S5;  -- Stay in S5 if no vehicle on "B"
                end if;

            when S6 =>
                Ga <= '0'; Ya <= '1'; Ra <= '0';
                Gb <= '0'; Rb <= '1';  -- Transition "A" from green to yellow
                NextState <= S7;

            when S7 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '1'; Rb <= '0';  -- "A" red, "B" green
                NextState <= S8;

            when S8 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '1'; Rb <= '0';
                NextState <= S9;

            when S9 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '1'; Rb <= '0';
                NextState <= S10;

            when S10 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '1'; Rb <= '0';
                NextState <= S11;

            when S11 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '1'; Rb <= '0';
                if Sa = '1' or Sb = '0' then
                    NextState <= S12;
                else
                    NextState <= S11;  -- Hold in S11 if Sb = 1 and Sa = 0
                end if;

            when S12 =>
                Ga <= '0'; Ra <= '1';
                Gb <= '0'; Yb <= '1'; Rb <= '0';  -- "B" yellow before switching back
                NextState <= S0;

            when others =>
                -- Default case for safety, should not occur
                NextState <= S0;
        end case;
    end process;

end Behavioral;

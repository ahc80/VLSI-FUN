library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLight is
    Port(
    clk, sa, sb : in STD_LOGIC;
    ga, gb, ya, yb, ra, rb : out STD_LOGIC);
end entity TrafficLight;

architecture sim of TrafficLight is
    signal nextState, State : bit_vector(3 downto 0):= "0000";
    begin
    process(clk) is begin
    if rising_edge(clk) then
        case State is
        when "0000" => 
	    nextState <= "0001"; 
            ga <= '1'; 
            ya <= '0'; 
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        when "0001" => 
	    nextState <= "0010"; 
            ga <= '1'; 
            ya <= '0';
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        when "0010" => 
	    nextState <= "0011"; 
            ga <= '1'; 
            ya <= '0'; 
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        when "0011" => 
	    nextState <= "0100"; 
            ga <= '1'; 
            ya <= '0'; 
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        when "0100" => 
	    nextState <= "0101"; 
            ga <= '1'; 
            ya <= '0'; 
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        when "0101" =>
            if(sb = '0') then
                nextState <= "0110"; 
                ga <= '0'; 
                ya <= '1'; 
                ra <= '0'; 
                gb <= '0'; 
                yb <= '0'; 
                rb <= '1';
            else
                nextState <= "0101"; 
                ga <= '1'; 
                ya <= '0'; 
                ra <= '0'; 
                gb <= '0'; 
                yb <= '0'; 
                rb <= '1';
            end if;
        when "0110" => 
	    nextState <= "0111"; 
            ga <= '0'; 
            ya <= '0'; 
            ra <= '1'; 
            gb <= '1'; 
            yb <= '0'; 
            rb <= '0';
        when "0111" => 
	    nextState <= "1000"; 
            ga <= '0'; 
            ya <= '0'; 
            ra <= '1'; 
            gb <= '1'; 
            yb <= '0'; 
            rb <= '0';
        when "1000" => 
	    nextState <= "1001"; 
            ga <= '0'; 
            ya <= '0'; 
            ra <= '1'; 
            gb <= '1'; 
            yb <= '0'; 
            rb <= '0';
        when "1001" => 
	    nextState <= "1010"; 
            ga <= '0'; 
            ya <= '0'; 
            ra <= '1'; 
            gb <= '1'; 
            yb <= '0'; 
            rb <= '0';
        when "1010" => 
	    nextState <= "1011"; 
            ga <= '0'; 
            ya <= '0'; 
            ra <= '1'; 
            gb <= '1'; 
            yb <= '0'; 
            rb <= '0';
        when "1011" =>
            if(sa = '1') or (sb = '0') then
                nextState <= "1100"; 
                ga <= '0'; 
                ya <= '0'; 
                ra <= '1'; 
                gb <= '0'; 
                yb <= '1'; 
                rb <= '0';
            else
                nextState <= "1011"; 
                ga <= '0'; 
                ya <= '0'; 
                ra <= '1'; 
                gb <= '1'; 
                yb <= '0'; 
                rb <= '0';
            end if;
        when others => 
	    nextState <= "0000"; 
            ga <= '1'; 
            ya <= '0'; 
            ra <= '0'; 
            gb <= '0'; 
            yb <= '0'; 
            rb <= '1';
        end case;
    end if;
    State <= nextState;
    end process;
end architecture sim;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_tb is
end top_level_tb;

architecture Behavioral of top_level_tb is

constant clk_period : time := 10 ns;

signal clk,rst,start: STD_LOGIC;
signal output:  STD_LOGIC_VECTOR (15 downto 0);

begin
clk_process :process -- set the clock signal
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

uut: entity work.top_level
port map(
clk => clk,
rst => rst,
start => start,
output => output
);

process
begin
wait for 100ns;                         -- convention, wait 100 ns  
wait until falling_edge(clk);

rst <= '1';
wait for clk_period;
rst <= '0';
start <= '1';
wait;
end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    generic ( data_size: NATURAL := 16);
            
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (data_size-1 downto 0);
           output : out STD_LOGIC_VECTOR (data_size-1 downto 0));
end reg;

architecture Behavioral of reg is
signal temp: STD_LOGIC_VECTOR (data_size-1 downto 0);

begin
    process(clk)
    begin
        if(rising_edge(clk))then
            if (rst = '1')then
                temp <=  (others => '0');            
            elsif ( en = '1')then
                temp <=  input;
            end if;
         end if;
    end process;
output <= temp;
end Behavioral;

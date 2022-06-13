library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity out_reg is   --one register for output signal to led
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC; 
           wen : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(15 downto 0);
           output: out STD_LOGIC_VECTOR(15 downto 0));
end out_reg;

architecture Behavioral of out_reg is

begin
    process(clk)
    begin
        if (rising_edge(clk))then
            if(rst = '1')then
                output <= (others => '0');
            elsif (wen = '1')then
                output <= input;
            end if;
        end if;
     end process;

end Behavioral;

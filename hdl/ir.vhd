library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ir is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ins : in STD_LOGIC_VECTOR (31 downto 0);
           ins_out : out STD_LOGIC_VECTOR (31 downto 0));
end ir;

architecture Behavioral of ir is

signal ins_out_int : STD_LOGIC_VECTOR (31 downto 0);

begin

    ir:process(clk)
    begin
        if (rising_edge(clk))then
            if (rst = '1')then
                ins_out_int <= (others => '0');
            else
                ins_out_int <= ins;
            end if;
        end if;
    end process;

ins_out <= ins_out_int;

end Behavioral;

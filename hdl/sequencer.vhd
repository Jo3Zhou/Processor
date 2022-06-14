library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sequencer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           offset : in STD_LOGIC_VECTOR (8 downto 0);
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           flag : in STD_LOGIC_VECTOR (7 downto 0);
           
           mia : out STD_LOGIC_VECTOR (7 downto 0));
end sequencer;

architecture Behavioral of sequencer is

signal pc_int : STD_LOGIC_VECTOR (7 downto 0);
signal mux_out : STD_LOGIC_VECTOR (7 downto 0);
signal mux_0 : STD_LOGIC_VECTOR (7 downto 0); --+1
signal mux_1 : STD_LOGIC_VECTOR (8 downto 0); --+offset
signal mia_int : STD_LOGIC_VECTOR (7 downto 0);   

begin

PC: process (clk)
begin
    if (rising_edge(clk))then
        if (rst = '1')then
            pc_int <= (others => '0');
        else
            pc_int <= mia_int;
        end if;
    end if;
end process;

mia_int <= mux_out;
mia<= mia_int;

mux_0 <= std_logic_vector(signed(pc_int) + 1);
mux_1 <= std_logic_vector(resize(signed(pc_int),8) + signed(offset));

mux_out <= std_logic_vector(resize(signed(mux_1),8)) when 
            (opcode = "110111") or        --uncon
            (opcode = "110000" and flag(0) = '1') or    --con
            (opcode = "110001" and flag(1) = '1') or
            (opcode = "110010" and flag(2) = '1') or
            (opcode = "110011" and flag(3) = '1') or
            (opcode = "110100" and flag(4) = '1') or
            (opcode = "110101" and flag(5) = '1') or
            (opcode = "110110" and flag(6) = '1')
            else mux_0;



end Behavioral;

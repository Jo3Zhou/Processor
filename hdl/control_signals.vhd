library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_signals is
    Port ( ins : in STD_LOGIC_VECTOR (31 downto 0);
    
           ra : out STD_LOGIC_VECTOR (4 downto 0);
           rb : out STD_LOGIC_VECTOR (4 downto 0);
           wa : out STD_LOGIC_VECTOR (4 downto 0);
           ma : out STD_LOGIC_VECTOR (15 downto 0);
           imm : out STD_LOGIC_VECTOR (15 downto 0);
           
           oen : out STD_LOGIC;
           s : out STD_LOGIC_VECTOR (2 downto 0);
           al : out STD_LOGIC_VECTOR (3 downto 0);
           sh : out STD_LOGIC_VECTOR (3 downto 0);
           wen : out STD_LOGIC;
           
           offset_jump : out STD_LOGIC_VECTOR (8 downto 0)
           );
end control_signals;

architecture Behavioral of control_signals is

signal opcode : STD_LOGIC_VECTOR (5 downto 0);
signal offset_loado_storo: STD_LOGIC_VECTOR (9 downto 0);

begin

opcode <= ins(31 downto 26);

---------------operands-----------
wa <= ins (4 downto 0) when (opcode = "000100") or --add
                            (opcode = "000101") or --sub
                            (opcode = "010001") or --and
                            (opcode = "010010") or --or
                            (opcode = "010011") or --xor
                            
                            (opcode = "001000") or --inc
                            (opcode = "001001") or --dec
                            (opcode = "010000") or --not
                            (opcode = "100000") or --move
                            (opcode = "100010") or --loadr
                            
                            (opcode = "000110") or --addi
                            (opcode = "000111") or --subi
                            (opcode = "010100") or --andi
                            (opcode = "010101") or --ori
                            (opcode = "010110") or --xori
                            
                            (opcode = "011000") or --shl
                            (opcode = "011001") or --shr
                            (opcode = "011010") or --rol
                            (opcode = "011011") or --ror
                            
                            (opcode = "100001") or --loadi
                            (opcode = "100011")    --loado
                            else "00000";

ra <= ins (9 downto 5) when (opcode = "000100") or --add
                            (opcode = "000101") or --sub
                            (opcode = "010001") or --and
                            (opcode = "010010") or --or
                            (opcode = "010011") or --xor
                            
                            (opcode = "001000") or --inc
                            (opcode = "001001") or --dec
                            (opcode = "010000") or --not
                            (opcode = "100000") or --move
                            
                            (opcode = "100010") or --loadr
                            (opcode = "100110") or --storr
                            
                            (opcode = "000110") or --addi
                            (opcode = "000111") or --subi
                            (opcode = "010100") or --andi
                            (opcode = "010101") or --ori
                            (opcode = "010110") or --xori
                            
                            (opcode = "011000") or --shl
                            (opcode = "011001") or --shr
                            (opcode = "011010") or --rol
                            (opcode = "011011") or --ror            
                            
                            (opcode = "110000") or --con jump
                            (opcode = "110001") or
                            (opcode = "110010") or
                            (opcode = "110011") or
                            (opcode = "110100") or
                            (opcode = "110101") or
                            (opcode = "110110") or
                            
                            (opcode = "100011") or --loado
                            (opcode = "100111")    --storo               
                                       
                            else "00000";

rb <= ins (14 downto 10) when (opcode = "000100") or --add
                              (opcode = "000101") or --sub
                              (opcode = "010001") or --and
                              (opcode = "010010") or --or
                              (opcode = "010011") else  --xor

       ins (4 downto 0) when  (opcode = "100101") or --stori
                              (opcode = "100110") or --storr
                              (opcode = "100111")    --storo
                              
                              else "00000";


ma <= ins (25 downto 10) when (opcode = "100001") or --loadi
                              (opcode = "100101")    --stori 
                              else (others => '0');

offset_jump <= ins (18 downto 10) when (opcode = "110111") or --uncon
                                       (opcode = "110000") or --con
                                       (opcode = "110001") or 
                                       (opcode = "110010") or 
                                       (opcode = "110011") or 
                                       (opcode = "110100") or 
                                       (opcode = "110101") or
                                       (opcode = "110110")
                                       else (others => '0');

offset_loado_storo <= ins (19 downto 10) when (opcode = "100011") or --loado
                                              (opcode = "100111")    --storo
                                              else (others => '0');
                                              
imm <= std_logic_vector(resize(unsigned(offset_loado_storo),16)) when (opcode = "100011") or (opcode = "100111") else    --storo,loado
       ins (25 downto 10) when 
       (opcode = "000110") or --addi
       (opcode = "000111") or --subi
       (opcode = "010100") or --andi
       (opcode = "010101") or --ori
       (opcode = "010110")    --xori
        else (others => '0');                            

---------------opcode-----------
s(0) <= '1' when
          (opcode = "000110") or --addi
          (opcode = "000111") or --subi
          (opcode = "010100") or --andi
          (opcode = "010101") or --ori
          (opcode = "010110") or--xori
          (opcode = "100011") or--loado
          (opcode = "100111")   --storo
          
          else '0';

s(1) <= '1' when
          (opcode = "100001") or --loadi
          (opcode = "100101")    --stori
          else '0';

s(2) <= '1' when
          (opcode = "100001") or --loadi
          (opcode = "100010") or --loadr
          (opcode = "100011")    --loado
          else '0';
           
with opcode select     
    al <= 
          "1010" when "000100",-- alu add
          "1010" when "000110",
          "1010" when "100011",
          "1010" when "100111",
     
          "1011" when "000101", --sub
          "1011" when "000111",
          
          "1000" when "001000", --+1
          "1001" when "001001", ---1
          "0111" when "010000", --not
          
          "0100" when "010001", --and
          "0100" when "010100", 
          
          "0101" when "010010", --or
          "0101" when "010101",
          
          "0110" when "010011", --xor
          "0110" when "010110",
          "1100" when "011000", --shift left
          "1101" when "011001", --shift right
          "1110" when "011010", --rotate left
          "1111" when "011011", --rotate right
          "0000" when others ;
          
sh <= ins(13 downto 10) when (opcode = "011000") or
                             (opcode = "011001") or
                             (opcode = "011010") or
                             (opcode = "011011")
                             else "0000";

oen <= '1' when 
           (opcode = "100101") or 
           (opcode = "100110") or 
           (opcode = "100111")
           else '0';
           
wen <= '1' when
           (opcode(5) = '0') or
           (opcode = "100000") or
           (opcode = "100001") or
           (opcode = "100010") or
           (opcode = "100011")
           else '0';

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic (n: NATURAL := 16);
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           x : in STD_LOGIC_VECTOR (log2(n)-1 downto 0);
           opcode: in STD_LOGIC_VECTOR(3 downto 0);
           flag: out STD_LOGIC_VECTOR(7 downto 0);
           alu_out : out STD_LOGIC_VECTOR (n-1 downto 0));
end ALU;

architecture Behavioral of ALU is

signal flagint: STD_LOGIC_VECTOR(7 downto 0);
signal output: STD_LOGIC_VECTOR (n-1 downto 0);

begin

 with opcode select     
    output <= a when "0000",
    
              a and b when "0100",
              a or b  when "0101",
              a xor b when "0110",
              not a   when "0111",
              
              std_logic_vector(signed(a) + 1)  when "1000",
              std_logic_vector(signed(a) - 1) when "1001",
              std_logic_vector(signed(a) + signed(b)) when "1010",
              std_logic_vector(signed(a) - signed(b)) when "1011",
              
              std_logic_vector(shift_left(signed(a), to_integer(unsigned(x)))) when "1100",
              std_logic_vector(shift_right(signed(a), to_integer(unsigned(x)))) when "1101",
              std_logic_vector(rotate_left(signed(a), to_integer(unsigned(x))))  when"1110",
              std_logic_vector(rotate_right(signed(a), to_integer(unsigned(x))))  when "1111",
              
              (others => 'U') when others ;
    
    
    flagint(0) <= '1' when (signed (output) = 0) else '0';
    flagint(1) <= '1' when (signed (output) /= 0) else '0';
    flagint(2) <= '1' when (signed(output) = 1) else '0';
    flagint(3) <= '1' when (signed(output) < 0 ) else '0';
    flagint(4) <= '1' when (signed(output) > 0) else '0';
    flagint(5) <= '1' when (signed(output) <= 0) else '0';
    flagint(6) <= '1' when (signed(output) >= 0) else '0';
    
    flagint(7) <= '1' when (opcode = "1010" and a(n-1) = '0' and b(n-1) = '0' and output(n-1) = '1') or
                           (opcode = "1010" and a(n-1) = '1' and b(n-1) = '1' and output(n-1) = '0') or
                           (opcode = "1011" and a(n-1) = '0' and b(n-1) = '1' and output(n-1) = '1') or
                           (opcode = "1011" and a(n-1) = '1' and b(n-1) = '0' and output(n-1) = '0') or
                           (opcode = "1000" and a(n-1) = '0' and output(n-1) = '1') or
                           (opcode = "1001" and a(n-1) = '1' and output(n-1) = '0')
             else '0';

    alu_out <= output;
    flag <= flagint;
    
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mmu is   --generate 7bits for instruction and data from 8bits and 16bits
    Port ( 
           mia : in STD_LOGIC_VECTOR (7 downto 0);
           
           mda : in STD_LOGIC_VECTOR (15 downto 0);
           
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0);
           
           ins_add : out STD_LOGIC_VECTOR (6 downto 0);
           
           data_add : out STD_LOGIC_VECTOR (6 downto 0);
           
           data_r : in STD_LOGIC_VECTOR (31 downto 0);
           data_w : out STD_LOGIC_VECTOR (31 downto 0);
           
           data_out_reg : out STD_LOGIC_VECTOR (15 downto 0);
           
           start : in STD_LOGIC;
           
           oen : in STD_LOGIC;
           wen : out STD_LOGIC
           );
end mmu;

architecture Behavioral of mmu is

signal start_int : STD_LOGIC_VECTOR (15 downto 0);
signal data_in_int : STD_LOGIC_VECTOR (15 downto 0);
signal data_out_int : STD_LOGIC_VECTOR (15 downto 0);
signal wen_int : STD_LOGIC;
begin

start_int(0) <= start;  --convert start signal into 16bits data
start_int(15 downto 1) <= (others =>'0');

ins_add(5 downto 0) <= mia(5 downto 0); --sequencer address
ins_add(6) <= '0';

data_add (5 downto 0) <= mda (6 downto 1);--data address
data_add (6) <= '1';
 
data_out <= data_r (31 downto 16) when mda(0) = '1' else --judge which 16 bits in 32 bits 
            data_r (15 downto 0);

data_w (31 downto 16) <= data_in_int when mda(0) = '1' else data_r(31 downto 16);
data_w (15 downto  0) <= data_in_int when mda(0) = '0' else data_r(15 downto 0);

data_in_int <= start_int when ((mda >= x"0100") and mda <= x"01FF" and mda = x"01F0") else data_in; 
wen <= '1' when (mda = x"01F0" or mda = x"01F8") else oen;  --start to address 01f0

data_out_reg <= data_in_int when (mda = x"01F8");--output register is linked to 01f8

end Behavioral;
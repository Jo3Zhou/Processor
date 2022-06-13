library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is                   -- connect datapath and control logic
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ins : in STD_LOGIC_VECTOR (31 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0);
           mda : out STD_LOGIC_VECTOR (15 downto 0);
           mia : out STD_LOGIC_VECTOR (7 downto 0);
           oen : out STD_LOGIC
           );
end top;

architecture Behavioral of top is

signal flag : STD_LOGIC_VECTOR (7 downto 0);

signal ra : STD_LOGIC_VECTOR (4 downto 0);
signal rb : STD_LOGIC_VECTOR (4 downto 0);
signal wa : STD_LOGIC_VECTOR (4 downto 0);
signal ma : STD_LOGIC_VECTOR (15 downto 0);
signal imm : STD_LOGIC_VECTOR (15 downto 0);

signal s : STD_LOGIC_VECTOR (2 downto 0);
signal al : STD_LOGIC_VECTOR (3 downto 0);
signal sh : STD_LOGIC_VECTOR (3 downto 0);
signal wen : STD_LOGIC;


begin

control_logic: entity work.control_logic
port map(
clk => clk, 
rst => rst,
    
ins => ins,
flag => flag,
    
ra => ra,
rb => rb,
wa => wa,
ma => ma,
imm => imm,
    
oen => oen,
s => s,
al => al,
sh => sh,
wen => wen,
    
mia =>mia);

datapath: entity work.datapath
port map(
clk => clk,
rst => rst,
    
ra => ra,
rb => rb,
wa => wa,
ma => ma,
imm => imm,
    
s1 => s(0),     --connect s1 to s(0) in control logic
s3 => s(1),
s4 => s(2),

al => al,
sh => sh,
wen => wen,
    
data_in => data_in,
data_out => data_out,
flag => flag,
mda => mda);

end Behavioral;






library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_logic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           ins : in STD_LOGIC_VECTOR (31 downto 0);
           flag : in STD_LOGIC_VECTOR (7 downto 0);
           
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
           
           mia : out STD_LOGIC_VECTOR (7 downto 0));
end control_logic;

architecture Behavioral of control_logic is

signal ins_int : STD_LOGIC_VECTOR (31 downto 0);
signal offset_jump : STD_LOGIC_VECTOR (8 downto 0);

begin

ir:entity work.ir
port map(
clk => clk,
rst => rst,
ins => ins,
ins_out => ins_int);

control_signals: entity work. control_signals
port map(
ins => ins_int,
    
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
offset_jump => offset_jump);

sequencer: entity work.sequencer
port map(
clk => clk,
rst => rst,
offset => offset_jump,
opcode => ins_int(31 downto 26),
flag => flag,
mia => mia);

end Behavioral;

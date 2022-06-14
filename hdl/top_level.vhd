library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_level is -- entity for connect datapath & control logic and mmu, memory, output register
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end top_level;

architecture Behavioral of top_level is

signal mia_int : STD_LOGIC_VECTOR (7 downto 0);
signal mda : STD_LOGIC_VECTOR (15 downto 0);
signal data_in : STD_LOGIC_VECTOR (15 downto 0);
signal data_out : STD_LOGIC_VECTOR (15 downto 0);
signal ins_add : STD_LOGIC_VECTOR (6 downto 0);
signal data_add : STD_LOGIC_VECTOR (6 downto 0);
signal data_r : STD_LOGIC_VECTOR (31 downto 0);
signal data_w : STD_LOGIC_VECTOR (31 downto 0);
signal data_out_reg : STD_LOGIC_VECTOR (15 downto 0);
signal wen : STD_LOGIC;
signal ins : STD_LOGIC_VECTOR (31 downto 0);
signal oen : STD_LOGIC;

begin
    mmu:entity work. mmu
    port map(
    mia => mia_int,
    mda => mda,
    data_in => data_in,
    data_out => data_out,
    ins_add => ins_add,
    data_add => data_add,
    data_r => data_r,
    data_w => data_w,
    data_out_reg => data_out_reg,
    start => start,
    oen => oen,
    wen => wen
    );
    
    out_reg: entity work.out_reg
    port map(
    clk => clk,
    rst => rst,
    wen => wen,
    input => data_out_reg,
    output => output
    );
    
    memory: entity work.dual_port_mem
    port map(
    clk => clk,
    wen => wen,
    ins_add => ins_add,
    ins => ins,
    data_add => data_add,
    data_in => data_w,
    data_out => data_r
    );
    
    ctrl_datapath:entity work.top
    port map(
    clk => clk,
    rst => rst,
    ins => ins,
    data_in => data_out,
    data_out => data_in,
    mda => mda,
    mia => mia_int,
    oen => oen
    );
    

end Behavioral;

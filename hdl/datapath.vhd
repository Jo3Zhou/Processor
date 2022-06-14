library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;


entity datapath is  --datapath instantiate alu & register bank and connect them with s1,s3,s4
    generic (data_size: NATURAL := 16;   --define parameterization 
             number_reg: NATURAL := 32); --data_size and number_reg
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           ra : in STD_LOGIC_VECTOR (log2(number_reg)-1 downto 0);
           rb : in STD_LOGIC_VECTOR (log2(number_reg)-1 downto 0);
           wa : in STD_LOGIC_VECTOR (log2(number_reg)-1 downto 0);
           ma : in STD_LOGIC_VECTOR (data_size-1 downto 0);
           imm : in STD_LOGIC_VECTOR (data_size-1 downto 0);
           
           s1 : in STD_LOGIC;
           s3 : in STD_LOGIC;
           s4 : in STD_LOGIC;
           
           al : in STD_LOGIC_VECTOR (3 downto 0);
           sh : in STD_LOGIC_VECTOR (log2(data_size)-1 downto 0);
           wen : in STD_LOGIC;
           
           data_in : in STD_LOGIC_VECTOR (data_size-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (data_size-1 downto 0);
           mda : out STD_LOGIC_VECTOR (data_size-1 downto 0);
           flag : out STD_LOGIC_VECTOR (7 downto 0));
end datapath;

architecture Behavioral of datapath is

signal s1_out: STD_LOGIC_VECTOR (data_size-1 downto 0); --internal signal
signal s3_out: STD_LOGIC_VECTOR (data_size-1 downto 0);
signal s4_out: STD_LOGIC_VECTOR (data_size-1 downto 0);


signal alu_out : STD_LOGIC_VECTOR (data_size-1 downto 0);
signal register_bank_out1 : STD_LOGIC_VECTOR (data_size-1 downto 0);
signal register_bank_out2 : STD_LOGIC_VECTOR (data_size-1 downto 0);
signal data_out_int : STD_LOGIC_VECTOR (data_size-1 downto 0);

begin


    s1_out <= register_bank_out2 when s1 = '0' else --mux for s1
              imm                when s1 = '1';

    s3_out <= alu_out when s3 = '0' else --mux for s3
              ma      when s3 = '1';

    s4_out <= alu_out when s4 = '0' else  --mux for s4
              data_in when s4 = '1';
    
    alu:entity work.ALU --instantiate alu
    port map(
    a => register_bank_out1,
    b => s1_out,
    x => sh,
    opcode => al,
    flag => flag,
    alu_out => alu_out
    );

    register_bank: entity work.top_rb --instantiate register bank
    port map(
    clk => clk,
    rst => rst,
    ra => ra,
    rb => rb,
    wa => wa,
    wen => wen,
    data_in => s4_out,
    data_out1 => register_bank_out1,
    data_out2 => register_bank_out2
    );
    
    data_out <= register_bank_out2;
    mda <= s3_out;
    
    
end Behavioral;

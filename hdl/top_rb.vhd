library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_rb is
    generic (data_size: NATURAL := 16;
             number_reg: NATURAL := 32);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           wen : in STD_LOGIC;
           wa : in STD_LOGIC_VECTOR ((log2(number_reg)-1) downto 0);
           ra : in STD_LOGIC_VECTOR (log2(number_reg)-1 downto 0);
           rb : in STD_LOGIC_VECTOR (log2(number_reg)-1 downto 0);           
           data_in : in STD_LOGIC_VECTOR (data_size-1 downto 0);
           data_out1 : out STD_LOGIC_VECTOR (data_size-1 downto 0);
           data_out2 : out STD_LOGIC_VECTOR (data_size-1 downto 0));
end top_rb;

architecture Behavioral of top_rb is
    type reg_bank_type is array (number_reg-1 downto 1) of std_logic_vector(data_size-1 downto 0);
    signal reg_bank_o : reg_bank_type;
    
    signal wev_int : STD_LOGIC_VECTOR (number_reg-1 downto 1);
    
begin
    
    reg_bank: for i in 1 to number_reg-1 generate
        
        one_reg: entity work.reg
            port map(clk => clk, 
                     rst => rst,
                     en => wev_int(i), 
                     input => data_in, 
                     output => reg_bank_o(i));
         data_out1 <= reg_bank_o(i) when unsigned(ra) = i else (others => 'Z');   -- Z = high-impedance             
         data_out2 <= reg_bank_o(i) when unsigned(rb) = i else (others => 'Z');   -- Z = high-impedance                        
         wev_int(i) <= '1' when (wen = '1' and unsigned(wa) = i)else '0';
         
    end generate;
    
    data_out1 <= (others => '0') when unsigned(ra) = 0 else (others => 'Z');
    data_out2 <= (others => '0') when unsigned(rb) = 0 else (others => 'Z');
    
end Behavioral;

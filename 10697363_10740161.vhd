-- Progetto di Reti Logiche
-- Andrea Iodice, C.P. 10607363
-- Sara Massarelli, C.P. 10740161

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity project_reti_logiche is
    port ( 
    i_clk : in std_logic; 
    i_rst : in std_logic; 
    i_start : in std_logic;
    i_w : in std_logic; 
    o_z0 : out std_logic_vector(7 downto 0);
    o_z1 : out std_logic_vector(7 downto 0);
    o_z2 : out std_logic_vector(7 downto 0); 
    o_z3 : out std_logic_vector(7 downto 0);
    o_done : out std_logic;
    o_mem_addr : out std_logic_vector(15 downto 0);
    i_mem_data : in std_logic_vector(7 downto 0);
    o_mem_we : out std_logic; 
    o_mem_en : out std_logic
           );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    signal b1, b0: std_logic := '0';
    signal valoreZ0, valoreZ1, valoreZ2, valoreZ3: std_logic_vector(7 downto 0):= (others => '0');
    signal indirizzo: std_logic_vector(15 downto 0):= (others => '0');
    type state_type is (RST, s0, s1, s2, s3, s4, s5, s6);   
    signal state: state_type:= RST;
begin
    process(i_clk,state)
        variable temp0, temp1, temp2, temp3: std_logic_vector(7 downto 0);
    begin
        if(i_clk'event and i_clk = '1') then
            case state is
                when RST =>
                    o_z0 <= "00000000";
                    o_z1 <= "00000000";
                    o_z2 <= "00000000";
                    o_z3 <= "00000000";
                    o_done <= '0';
                    o_mem_addr <= "0000000000000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    b1 <= 'U';
                    b0 <= 'U';
                    indirizzo <= "0000000000000000";
                    valoreZ0 <= "00000000";
                    valoreZ1 <= "00000000";
                    valoreZ2 <= "00000000";
                    valoreZ3 <= "00000000";
                    temp0 := valoreZ0;
                    temp1 := valoreZ1;
                    temp2 := valoreZ2;
                    temp3 := valoreZ3;
                    if(i_rst = '1')then
                        state <= RST;
                     elsif(i_rst = '0' and i_start = '0')then
                        state <= s0;
                     elsif(i_rst = '0' and i_start = '1') then
                        b1 <= i_w;
                        state <= s1;
                     else
                        state <= RST;
                     end if;
    
                when s0 =>
                    if(i_start = '0' and i_rst = '0')then
                        state <= s0;
                    elsif(i_start = '1' and i_rst = '0')then
                        b1 <= i_w;                      
                        state <= s1;
                    elsif(i_rst = '1')then 
                        state <= RST;
                    else 
                        state <= RST;
                    end if;
            
                when s1 =>
                    if(i_start = '1' and i_rst = '0') then
                        b0 <= i_w;
                        state <= s2;
                    else 
                        state <= RST;
                    end if;
            
                when s2 =>
                    if(i_rst = '0' and i_start = '1') then
                        indirizzo <= std_logic_vector((unsigned(indirizzo) sll 1));
                        indirizzo(0) <= i_w;
                        state <= s2;
                    elsif(i_rst = '0' and i_start = '0') then
                        o_mem_addr <= indirizzo;
                        o_mem_we <= '0';
                        o_mem_en <= '1';
                        state <= s3;
                    else
                        state <= RST;
                    end if;
              
                when s3 =>
                    if(i_rst = '0') then
                        state <= s4;
                    else
                        state <= RST;
                    end if;
            
                when s4 =>
                    if(i_rst = '0') then
                        temp0 := valoreZ0;
                        temp1 := valoreZ1;
                        temp2 := valoreZ2;
                        temp3 := valoreZ3;
                        if(b1 = '0' and b0 = '0') then
                            temp0 := i_mem_data;
                            valoreZ0 <= i_mem_data;
                        elsif(b1 = '0' and b0 = '1') then 
                            temp1 := i_mem_data;               
                            valoreZ1 <= i_mem_data;
                        elsif(b1 = '1' and b0 = '0') then  
                            temp2 := i_mem_data;                   
                            valoreZ2 <= i_mem_data;
                        elsif(b1 = '1' and b0 = '1')then 
                            temp3 := i_mem_data;
                            valoreZ3 <= i_mem_data;    
                        end if;
                        o_z0 <= temp0;
                        o_z1 <= temp1;
                        o_z2 <= temp2;
                        o_z3 <= temp3;
                        o_done <= '1';
                        state <= s5;
                    else
                        state <= RST;
                    end if;
         
                when s5 =>
                    if(i_rst = '0') then
                        o_z0 <= "00000000";
                        o_z1 <= "00000000";
                        o_z2 <= "00000000";
                        o_z3 <= "00000000";
                        o_done <= '0';
                        o_mem_addr <= "0000000000000000";
                        o_mem_we <= '0';
                        o_mem_en <= '0';
                        state <= s6;
                    else
                        state <= RST;
                    end if;

                when s6 =>
                    if(i_rst = '1') then
                        state <= RST;
                    elsif(i_start = '1') then
                        b1 <= i_w;
                        b0 <= 'U';
                        indirizzo <= "0000000000000000";
                        state <= s1;
                    elsif(i_start = '0') then
                        b1 <= 'U';
                        b0 <= 'U';
                        indirizzo <= "0000000000000000";
                        state <= s0;
                    else
                        state <= RST;
                    end if;
                                
                when others =>
                    state <= RST;
            end case;
        end if;
    end process;
end Behavioral;

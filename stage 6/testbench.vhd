library IEEE;
use work.myTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity processor_tb is 
    -- empty
end processor_tb;
-- implementing the architecture of the test_bench
architecture implement_tb of processor_tb is
    component GlueCode is 
        port(
            clock, reset: in std_logic
        );
    end component;
    signal clk,rst: std_logic:='0';
begin
    gc: GlueCode port map(clk, rst);
    process
    begin  
        clk <= '0';    
        rst<= '1';      
        wait for 10 ns;
        rst<= '0';      
        for i in 0 to 300 loop  
            clk <= not clk; 
            wait for 10 ns; 
        end loop;
        wait;
    end process;
end implement_tb;
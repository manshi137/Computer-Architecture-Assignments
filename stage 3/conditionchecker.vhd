library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity cond_check is
    port(
        Z,C,N,V: in std_logic;
        condition: in std_logic_vector(3 downto 0);
        cond_checker_output: out std_logic
    );
end cond_check;

architecture cond_check_arch of cond_check is 
    begin 
    process(condition,Z)
        begin
        if(condition="0000" and Z='1') then 
            cond_checker_output<='1';     -- beq condition
        elsif (condition="0001" and Z='0') then
            cond_checker_output<='1';     -- bne condition 
        elsif (condition="0010" and C='1') then
            cond_checker_output<='1';
        elsif(condition="0011" and C='0') then
            cond_checker_output<='1';
        elsif(condition="0100" and N='1') then 
            cond_checker_output<='1';
        elsif(condition="0101" and N='0') then    
            cond_checker_output<='1';
        elsif(condition="0110" and V='1') then    
            cond_checker_output<='1';
        elsif(condition="0111" and V='0') then
            cond_checker_output<='1';
        elsif(condition="1000" and Z='0' and C='1') then 
            cond_checker_output<='1';
        elsif(condition="1001" and Z='1' and C='0') then
            cond_checker_output<='1';
        elsif(condition="1010" and N=V) then
            cond_checker_output<='1';
        elsif(condition="1011" and not(N=V)) then
            cond_checker_output<='1';
        elsif(condition="1100" and Z='0' and N=V) then
            cond_checker_output<='1';
        elsif(condition="1101" and Z='1' and not(N=V)) then
            cond_checker_output<='1';
        elsif (condition= "1110") then                 -- b or bal condition
            cond_checker_output<='1';
        else cond_checker_output <='0';       
        end if;
        end process;
end cond_check_arch;
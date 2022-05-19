library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity pc_io is 
port(
    pc_in:                  in std_logic_vector(31 downto 0);
    pc_out:                 out std_logic_vector(31 downto 0);
    clock,reset:            in std_logic ;
    cond_checker_output:    in std_logic;
    instruction:            in std_logic_vector(31 downto 0);
    offset:                 in std_logic_vector(23 downto 0)
);
end pc_io;

architecture pc_arch of pc_io is 
begin 
process(clock,reset)
	variable temp:std_logic_vector(31 downto 0);
    variable signbit: std_logic;
    variable offsetext: std_logic_vector(31 downto 0);
    begin      
    	if(rising_edge(clock)) then
        	temp:= pc_in+4;
        	if (reset='1') then temp:= X"00000000"; 
        	elsif (instruction(27 downto 26)= "10") then 
        		if(offset(23)='1') then 
                temp:=temp+4+std_logic_vector("111111"&offset&"00");
                else temp:=temp+4+std_logic_vector("000000"&offset&"00");
                end if;
            end if;
        
 		pc_out<=temp;
        end if;
end process;
end pc_arch;
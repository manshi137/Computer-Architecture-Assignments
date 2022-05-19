library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity pc_io is 
port(
    pc_in:                  in std_logic_vector(31 downto 0);
    pc_out:                 out std_logic_vector(31 downto 0);
    clock,reset:            in std_logic 
);
end pc_io;

architecture pc_arch of pc_io is 
begin 
process(clock,reset)
    begin      
    	if(rising_edge(clock)) then
        	if (reset='1') then pc_out<= X"00000000"; 
            else pc_out<=pc_in;
            end if;
        end if;
end process;
end pc_arch;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rf_io is
    port(
    rad1,rad2,wad: in std_logic_vector(3 downto 0);
    rf_write_enable: in std_logic;
    clock: in std_logic;
    rd1,rd2: out std_logic_vector(31 downto 0);
    wd:in std_logic_vector(31 downto 0)
    );
end rf_io;

architecture rf_arch of rf_io is
	type rf_array is array (0 to 15) of std_logic_vector(31 downto 0);
    signal rf: rf_array:= (others => X"00000000");
    begin  
        rd1<= rf (to_integer(unsigned(rad1))); -- convert 4 bit address to integer for using as index
        rd2<= rf (to_integer(unsigned(rad2)));
        process(clock) is 
        begin  
            if rising_edge(clock) then 
                if rf_write_enable='1' then rf(TO_INTEGER(unsigned(wad)))<= wd; end if;
            end if;   
        end process ;
end rf_arch;
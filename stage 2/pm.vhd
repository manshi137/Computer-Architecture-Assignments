LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pm_io is
    port(
        pm_ad: in std_logic_vector(5 downto 0); --6bit address to access 64 std_logic_vectors 
        pm_ins: out std_logic_vector(31 downto 0)
    );
end pm_io;

architecture pm_arch of pm_io is
    type prog_m is array (0 to 63) of std_logic_vector(31 downto 0);
    --initalising array with 64 values, each value of 32 bits
    signal prog_mem : prog_m:=(0 => X"E3A0000A",
1 => X"E3A01005",
2 => X"E5801000",
3 => X"E2811002",
4 => X"E5801004",
5 => X"E5902000",
6 => X"E5903004",
7 => X"E0434002", others => X"00000000"
); 
    begin
        process(pm_ad)
        begin 
            pm_ins <= prog_mem((TO_INTEGER(unsigned(pm_ad)))); --address vector is converted to integer to use as index
        end process;
    end pm_arch;




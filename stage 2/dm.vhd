library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity dm_io is 
    port(
        dm_wadd: in std_logic_vector(5 downto 0);--6 bit write add or write
        dm_wd:  in std_logic_vector(31 downto 0);--32 bit word to write in dm_wadd
        dm_rd: out std_logic_vector(31 downto 0);--read output
        clock: in std_logic;
        dm_write_enable: in std_logic_vector(3 downto 0)
    );
end dm_io;

architecture dm_arch of dm_io is
    type data_mem is array (0 to 63) of std_logic_vector(31 downto 0);
    signal data_memory : data_mem ; 
    signal ad :INTEGER RANGE 0 TO 63;
    signal r_ad :INTEGER RANGE 0 TO 63;
    begin
        ad<= TO_INTEGER(unsigned(dm_wadd)); --convert 6 bit to integer to use as index of array
        dm_rd<= data_memory(ad); --read data at ad in data_memory - unclocked
        process (clock)
        begin
            if(rising_edge(clock)) then --write is clocked
                    if dm_write_enable="0001" then 
                    data_memory(ad)(7 downto 0)<=dm_wd(7 downto 0);     --write in least significant byte
                    elsif dm_write_enable="0010" then 
                    data_memory(ad)(15 downto 8)<=dm_wd(7 downto 0);    
                    elsif dm_write_enable="0100" then 
                    data_memory(ad)(23 downto 16)<=dm_wd(7 downto 0);
                    elsif dm_write_enable ="1000" then 
                    data_memory(ad)(31 downto 24)<=dm_wd(7 downto 0);   --write in most significant byte
                    elsif dm_write_enable="0011" then  
                    data_memory(ad)(15 downto 0)<=dm_wd(15 downto 0);   --write in left half word
                    elsif dm_write_enable="1100" then
                    data_memory(ad)(31 downto 16)<=dm_wd(15 downto 0);  --write in right half word
                    elsif dm_write_enable="1111" then 
                    data_memory(ad)<=dm_wd;                             --write full word
                    end if;
            end if;
        end process;
    end dm_arch;




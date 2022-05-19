library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity mem_io is 
    port(
        mem_ad: in std_logic_vector(5 downto 0);--6 bit write add or write
        mem_wd:  in std_logic_vector(31 downto 0);--32 bit word to write in mem_wadd
        mem_rd: out std_logic_vector(31 downto 0);--read output
        clock,IorD: in std_logic:='0';--0 for I , 1 for D
        mem_write_enable: in std_logic_vector(3 downto 0)
    );
end mem_io;

architecture mem_arch of mem_io is
    type prog_memory is array (0 to 63) of std_logic_vector(31 downto 0);
    type data_memory is array (0 to 63) of std_logic_vector(31 downto 0);
    signal d_memory: data_memory:=(others=>X"00000000");
    signal p_memory :     prog_memory := (0 => X"E3A00000",
1 => X"E3A01000",
2 => X"E0800001",
3 => X"E2811001",
4 => X"E3510005",
5 => X"1AFFFFFB", others => X"00000000"
);

    
    begin
        
        process(IorD, mem_ad)
        begin
            if(IorD='0') then mem_rd<= p_memory( TO_INTEGER(unsigned(mem_ad))); --read data at ad from prog mem - unclocked 
            else mem_rd<=d_memory( TO_INTEGER(unsigned(mem_ad)));
            end if;
        end process;
        --read outside process because it is unclocked
        process (clock)
        begin
            if(rising_edge(clock)) then --write is clocked
                    if mem_write_enable="0001" then 
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(7 downto 0)<=mem_wd(7 downto 0);     --write in least significant byte
                    elsif mem_write_enable="0010" then 
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(15 downto 8)<=mem_wd(7 downto 0);    
                    elsif mem_write_enable="0100" then 
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(23 downto 16)<=mem_wd(7 downto 0);
                    elsif mem_write_enable ="1000" then 
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(31 downto 24)<=mem_wd(7 downto 0);   --write in most significant byte
                    elsif mem_write_enable="0011" then  
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(15 downto 0)<=mem_wd(15 downto 0);   --write in left half word
                    elsif mem_write_enable="1100" then
                    d_memory( TO_INTEGER(unsigned(mem_ad)))(31 downto 16)<=mem_wd(15 downto 0);  --write in right half word
                    elsif mem_write_enable="1111" then 
                    d_memory( TO_INTEGER(unsigned(mem_ad)))<=mem_wd;                             --write full word
                    end if;
            end if;
        end process;
        --end if;
    end mem_arch;






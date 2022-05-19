LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rf_tb is
end rf_tb;

architecture rf_tb_arch of rf_tb is
component rf_io
port(
    rad1,rad2,wad: in std_logic_vector(3 downto 0);
    write_enable: in std_logic;
    clock: in std_logic;
    rd1,rd2: out std_logic_vector(31 downto 0);
    wd:in std_logic_vector(31 downto 0)
    );
end component;

signal radd1, radd2, wadd: std_logic_vector(3 downto 0):=(others=>'0');
signal rdata1, rdata2: std_logic_vector(31 downto 0):=(others=>'0');
signal wdata :std_logic_vector(31 downto 0):=(others=>'0');
signal w_enable: std_logic:='0';
signal clock: std_logic:='0';

begin 
    dut: rf_io port map(radd1,radd2,wadd,w_enable,clock,rdata1,rdata2,wdata);
    process
    begin 
        radd1<= "0000";
        radd2<= "0001";
        clock<='1'; --clock initialised to 1
        w_enable<='1';
        wadd<="0000";
        for I in 0 to 15 loop --loop to write on first 15 registers 
            wait for 10 ns; --clock=0
            clock<=not(clock);
            wdata<=wdata+2; --increment value of write data
            wadd<=wadd+1; -- increment write address by 1 to write in next address
            wait for 10 ns;
            clock<=not(clock); --clock =1
        end loop;
        for I in 0 to 7 loop --loop to read first 15 registers         
            radd1<=radd1+2; --covers all even addresses
            radd2<=radd2+2; --covers all odd addresses
            wait for 10 ns;
        end loop;
        wait;
    end process;
end rf_tb_arch;


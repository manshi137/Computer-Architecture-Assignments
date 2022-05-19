LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dm_tb is
end dm_tb;

architecture dm_tb_arch of dm_tb is
    signal wadd: std_logic_vector(5 downto 0):=(others=>'0');
    signal wdata : std_logic_vector(31 downto 0);
    signal rdata  : std_logic_vector(31 down to 0);
    signal clk: std_logic:='0';
    signal w_enable: std_logic_vector(3 downto 0):=(others=>'0');

    component dm_io is 
    port(
        dm_wadd: in std_logic_vector(5 downto 0);--6 bit write add
        dm_wd:  in std_logic_vector(31 downto 0);--32 bit write data
        dm_rd: out std_logic_vector(31 downto 0);--32 bit read ouput
        clock: in std_logic;
        dm_write_enable: in std_logic_vector(3 downto 0);
    );
    end component;    
    begin 
        dut : dm_io port map (wadd , wdata , rdata , clk , w_enable);
        process 
        begin
        clk<='1';--clk initialised to 1
        wadd<="000000";
        wdata<="00000000000000000000000000000000";
        w_enable<="0001";
        for I in 0 to 5 loop --loop to write in leftmost byte for first 5 words in data_memory
            wait for 10 ns;
            clk<= not(clk);--clk=0
            wdata<=wdata+2;--increment write data value
            wadd<=wadd+1;--increment write address
            wait for 10 ns;
            clk<=not(clk);--clk=1
        end loop;

        wdata<="00000000000000000000000000001000";
        w_enable<="0011";
        for I in 0 to 5 loop --loop to write in leftmost 2 byte for next 5 words in data_memory
            wait for 10 ns;
            clk<= not(clk);
            wdata<=wdata+2; --increment write data value
            wadd<=wadd+1; --increment write address
            wait for 10 ns;
            clk<=not(clk);
        end loop;

        wdata<="00000000000000000000000001000000";
        w_enable<="1111";
        for I in 0 to 5 loop --loop to write full word for first 5 words in data_memory
            wait for 10 ns;
            clk<= not(clk);
            wdata<=wdata+2; --increment write data value
            wadd<=wadd+1; --increment write address
            wait for 10 ns;
            clk<=not(clk);
        end loop;

        wadd<="000000";
        for I in 0 to 10 loop
            wait for 10 ns;
            wadd<=wadd+1;
        end loop;

        wait;
        end process;
        end dm_tb_arch;



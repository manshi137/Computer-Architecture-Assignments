LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity condcheck_tb is 
end condcheck_tb;

architecture condcheck_tb_arch of condcheck_tb is 
component cond_check is
    port(
        Z,C,N,V: in std_logic;
        condition: in std_logic_vector(3 downto 0);
        cond_checker_output: out std_logic
    );
    end component;
signal cond_checker_op : std_logic:='0';
signal Z:std_logic:='0';
signal C:std_logic:='0';
signal N:std_logic:='0';
signal V:std_logic:='0';
signal condn: std_logic_vector (3 downto 0):=(others=>'0');
begin 
    dut: cond_check port map(Z,C,N,V, condn, cond_checker_op);
    process 
    begin 
    condn<="0000";
    Z<='1';
    wait for 10 ns;
    Z<='0';
    wait for 10 ns;
    condn<="0001";
    Z<='0';
    wait for 10 ns;
    Z<='1';
    wait for 10 ns;
    condn<="1110";
    Z<='0';
    wait for 10 ns;
    Z<='1';
    wait for 10 ns;
    condn<="1111";
    wait for 10 ns;
    wait;
    end process;
    end condcheck_tb_arch;



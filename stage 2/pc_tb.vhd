LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pc_tb is 
end pc_tb;

architecture pc_tb_arch of pc_tb is 
component pc_io 
port(
    pc_in: in std_logic_vector(31 downto 0);
    pc_out: out std_logic_vector(31 downto 0);
    clock,reset: in std_logic ;
    cond_checker_output: in std_logic;
    instruction: in std_logic_vector(31 downto 0);
    offset: in std_logic_vector(23 downto 0);

   
);
end component;

signal pcin : std_logic_vector(31 downto 0):=(others=>'0');
signal  instr : std_logic_vector(31 downto 0):=(others=>'0');
signal pcout : std_logic_vector(31 downto 0);
signal clk, reset: std_logic:='0';
signal cond_check_op: std_logic;
signal offset: std_logic_vector(23 downto 0);

begin 
    DUT : pc_io port map(pcin, pcout, clk,reset, cond_check_op, instr,offset);
    process
    begin 
        pcin<="00000000000000000000000000000000";
        instr<="00001000000000000000000000000010"; --2 , 2*4+8=16
        offset<="000000000000000000000010";
        clk<='0';
        cond_check_op<='1';

        for I in 0 to 5 loop
            clk<= not(clk); --clk=1
            wait for 10 ns;
            pcin<= pcin + 1;
            wait for 10 ns;
            clk<=not(clk);
        end loop;
        wait;
    end process;
end pc_tb_arch;









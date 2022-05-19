LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pm_tb is
end pm_tb;

architecture pm_tb_arch of pm_tb is
    component pm_io
    port(
        pm_ad: in std_logic_vector(5 downto 0);
        pm_ins: out std_logic_vector(31 downto 0)
    );
    end component;
    signal add: std_logic_vector(5 downto 0):= (others=>'0');
    signal instr: std_logic_vector(31 downto 0):= (others=>'0');
    begin
        DUT: pm_io port map(add, instr);
        process
        begin
        add<="000000";
        for I in 0 to 16 loop --loop to read first 16 values in prog memory
            wait for 10 ns;
            add<=add+1;
        end loop;
        wait;
        end process;
    end pm_tb_arch;
    



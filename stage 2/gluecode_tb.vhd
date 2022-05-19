-- designing the test bench
library IEEE;
use work.myTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity gluecode_tb is
-- empty
end gluecode_tb;
-- implementing the architecture of the test_bench
architecture gluecode_tb_arch of gluecode_tb is
    component gluecode is
    port(
    reset, clock: in std_logic
    );
    end component;
    signal clock,reset: std_logic:='0';
    begin
    gc: gluecode port map(clock,reset);
    process
        begin
        wait for 1 ns;
        clock <= '1'; 
        reset<= '1';
        wait for 10 ns;
        reset<= '0';
        for i in 0 to 45 loop 
        clock <= not clock;
        wait for 10 ns;
        end loop;
        wait;
    end process;
end gluecode_tb_arch;
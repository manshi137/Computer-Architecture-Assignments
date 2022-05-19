LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity flag_tb is 
end flag_tb;
architecture flag_tb_arch of flag_tb is 
component flag 
port(
        instr_class: in instr_class_type;
        DP_subclass : in DP_subclass_type;
        instruction : in std_logic_vector(31 downto 0);
        clock: in std_logic;
        s_bit: in std_logic;				--set flags if s=1 else not
        shift_rot: in std_logic;
        shift_carry: in std_logic;
        result: in std_logic_vector(31 downto 0);
        msb_oper1: in std_logic;
        msb_oper2: in std_logic;
        Z, N, C, V: out std_logic
    );
end component;

signal instr_class: instr_class_type;
signal DP_subclass : DP_subclass_type;
signal instruction : std_logic_vector(31 downto 0);
signal clock,s,cout: std_logic:='0';
signal res: std_logic_vector(31 downto 0):=(others=>'0');
signal msb_op1:std_logic:='0';
signal msb_op2:std_logic:='0';
signal shift_rot,shift_carry: std_logic:='0';
signal Z, N, C, V: std_logic;
begin 
    dut:  flag port map (instr_class, DP_subclass, instruction, clock,s,shift_rot,cout,shift_carry,res,msb_op1,msb_op2,Z,N,C,V);
    process 
    
    begin 
    clock<='0';
    s<='1';
    cout<='1';
    msb_op1<='1';
    msb_op2<='1';
    wait for 10 ns;
    instruction<="00000011010000000000000000000000";
    instr_class<=DP;
    DP_subclass<=comp;
    res<="00000000000000000000000000000000";
    clock<= not clock;
    wait for 5 ns;
    clock<= not clock;
    wait for 10 ns;
    --dp, comp, 
	res<="10000000000000000000000000000000";
    clock<= not clock;
    wait for 5 ns;
    clock<= not clock;
    wait for 10 ns;
    res<="00000000000000000000000000000000";
    clock<= not clock;
    wait for 5 ns;
    clock<= not clock;
	DP_subclass<=arith;
    s<='0';
    wait for 10 ns;
    s<='1';
    clock<= not clock;
    wait for 5 ns;
    clock<= not clock;
    for i in 0 to 5 loop -- loop till all the instructions are over
    clock <= not clock; -- in each loop reverse the clock
    wait for 10 ns; -- after 10 ns
    end loop;
    wait for 10 ns;
    wait;
    end process;
    end flag_tb_arch;
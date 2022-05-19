LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_tb is 
end alu_tb;

architecture alu_tb_arch of alu_tb is 
component alu_io 
port(
    operand1 :in std_logic_vector(31 downto 0);
    operand2 :in std_logic_vector(31 downto 0);
    carryin :in std_logic;
    opcode :in std_logic_vector(3 downto 0);
    carryout : out std_logic;
    msb_oper1: out std_logic;
    msb_oper2: out std_logic;
    result :out std_logic_vector(31 downto 0)
    );
end component;

signal op1,op2 :std_logic_vector(31 downto 0);
signal cin: std_logic;
signal op :std_logic_vector(3 downto 0):= (others => '0');
signal cout: std_logic;
signal msb_oper1: std_logic;
signal msb_oper2: std_logic;
signal res: std_logic_vector(31 downto 0);

begin
	DUT: alu_io port map(op1,op2,cin,op,cout, msb_oper1, msb_oper2,res);
	process
    variable opc_iter: std_logic_vector(3 downto 0);
	begin 
		op1<="00000000000000000000000000000011";
		op2<="00000000000000000000000000000101";
		cin<='1';
		op<= "0000";
        for I in 0 to 15 loop 
            opc_iter:=op;
            op<= opc_iter + "0001";
            wait for 10 ns;
        end loop;
		wait ;
	end process;
end alu_tb_arch;
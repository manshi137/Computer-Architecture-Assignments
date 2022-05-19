LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity decoder_tb is 
end decoder_tb;

architecture decoder_tb_arch of decoder_tb is 
component Decoder is 
port (
    instruction : in  word;
    instr_class : out  instr_class_type;
    operation : out optype;
    opcode : out std_logic_vector(3 downto 0);
    DP_subclass : out DP_subclass_type;
    DP_operand_src : out DP_operand_src_type;
    load_store : out load_store_type;
    DT_offset_sign : out DT_offset_sign_type;
    rad1: out std_logic_vector(3 downto 0);
    wad: out std_logic_vector(3 downto 0);
    condition: out std_logic_vector(3 downto 0)
    );
end component;
signal instruction : std_logic_vector(31 downto 0):=(others=>'0');
signal instr_class : instr_class_type;
signal operation : optype;
signal opcode : std_logic_vector(3 downto 0);

signal DP_subclass : DP_subclass_type;
signal DP_operand_src :  DP_operand_src_type;
signal load_store : load_store_type;
signal DT_offset_sign : DT_offset_sign_type;
signal rad1: std_logic_vector(3 downto 0);
signal wad: std_logic_vector(3 downto 0);

signal condition: std_logic_vector(3 downto 0);

begin 
    dut: Decoder port map(instruction, instr_class, operation,opcode, DP_subclass, DP_operand_src,
                load_store, DT_offset_sign, rad1,wad, condition);
    process 
    begin 
    instruction<="00000000010010001001000000001111";
    --10010001001000000001111
    --dp, 0, arith, r8, r9, , shift=0, r15
    wait for 5 ns;
    wait;
    end process;
end decoder_tb_arch;


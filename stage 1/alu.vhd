library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity alu_io is
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
end alu_io;

architecture alu_arch of alu_io is 
begin
    process(opcode,operand1,operand2)
    variable res_w_overflow: std_logic_vector(32 downto 0);
    variable sres_w_overflow:std_logic_vector(32 downto 0);
    variable sresult :std_logic_vector(31 downto 0);
    begin
        msb_oper1<=operand1(31);
        msb_oper2<=operand2(31);

        case opcode is
        when "0000"=> --and
            sres_w_overflow := ('0' & operand1) and ('0' & operand2);
        when "0001"=> --xor
            sres_w_overflow := ('0' & operand1) xor ('0' & operand2);
        when "0010"=> --sub
            sres_w_overflow:= ('0' & operand1) + not('0' & operand2) + 1;
        when "0011"=> --rsb
            sres_w_overflow:= not('0' & operand1)+ ('0' & operand2) + 1;
        when "0100"=> --add
            sres_w_overflow:= ('0' & operand1) + ('0' & operand2);
        when "0101"=> --adc
            sres_w_overflow:= ('0' & operand1) + ('0' & operand2) + carryin;
        when "0110"=> --sbc
            sres_w_overflow:= ('0' & operand1) + not('0' & operand2) + carryin;
        when "0111"=> --rsc
            sres_w_overflow:= not('0' & operand1) + ('0' & operand2) + carryin;
        when "1000"=> --tst
            sres_w_overflow := ('0' & operand1) and ('0' & operand2);
        when "1001"=> --teq
            sres_w_overflow := ('0' & operand1) xor ('0' & operand2);
        when "1010"=> --cmp
            sres_w_overflow:=('0' & operand1) + not('0' & operand2) + 1;
        when "1011"=> --cmn
            sres_w_overflow:= ('0' & operand1) + ('0' & operand2);
        when "1100"=> --orr
            sres_w_overflow := ('0' & operand1) or ('0' & operand2);
        when "1101"=> --mov
            sres_w_overflow := ('0' & operand2);
        when "1110"=> --bic
            sres_w_overflow := ('0' & operand1) and not('0' & operand2);
        when "1111"=> --mvn
            sres_w_overflow := not('0' & operand2);
        when others =>
        	sres_w_overflow:= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end case;
        res_w_overflow:= std_logic_vector(sres_w_overflow);
        result<= res_w_overflow(31 downto 0);
        carryout<= res_w_overflow(32);  
    end process;
end alu_arch;
    





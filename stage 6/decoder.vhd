library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
    Port (
        instruction : in  word;
        instr_class : out  instr_class_type;
        operation : out std_logic_vector(3 downto 0);
        DP_subclass : out DP_subclass_type;
        DP_operand_src : out DP_operand_src_type;
        load_store : out load_store_type;
        DT_offset_sign : out DT_offset_sign_type;
        condition: out std_logic_vector(3 downto 0);
        branch_offset: out std_logic_vector(23 downto 0);
        shifttype:  out shift_type;
        shift_src: out shift_src_type;
        DT_OFFSET: out DP_operand_src_type
        );
end Decoder;

architecture Behavioral of Decoder is
        type oparraytype is array (0 to 15) of optype;
        constant oparray : oparraytype :=
        (andop, eor, sub, rsb, add, adc, sbc, rsc,
        tst, teq, cmp, cmn, orr, mov, bic, mvn);
begin    
operation <=  instruction (24 downto 21);
with instruction (24 downto 22) select
DP_subclass <= arith when "001" | "010" | "011",
logic when "000" | "110" | "111",
comp when "101",
test when others;
DP_operand_src <= reg when instruction (25) = '0' else imm;
DT_offset_sign <= plus when instruction (23) = '1' else minus;

condition<= instruction(31 downto 28);
branch_offset<= instruction(23 downto 0);

with  instruction(6 downto 5) select
shifttype<= LSL when "00", 
LSR when "01",
ASR when "10",
ROT when others; 

shift_src<= reg when instruction(4)='1' else const;
DT_OFFSET <= reg when instruction(25) = '1' else imm;
process(instruction)
begin            
if(instruction(27 downto 26)="01") then
if(instruction(20)='1' and instruction(22)='0') then
    load_store <= ldr;
elsif(instruction(20)='0' and instruction(22)='0') then
    load_store <= str;
elsif(instruction(20)='1' and instruction(22)='1') then
    load_store <= ldrb;
elsif(instruction(20)='0' and instruction(22)='1') then
    load_store <= strb;
    end if;
    else
if(instruction(20)='0' and instruction(6 downto 5)="01") then
    load_store <= strh;
elsif(instruction(20)='1' and instruction(6 downto 5)="01") then
    load_store <= ldrh;
elsif(instruction(20)='1' and instruction(6 downto 5)="10") then
    load_store <= ldrsb;
elsif(instruction(20) = '1' and instruction(6 downto 5)="11") then
    load_store <= ldrsh;
end if;
end if;
if(instruction(27 downto 26) = "01") then
    instr_class <= DT;
elsif(instruction(27 downto 25) = "000" and instruction(4) = '1' and instruction(7) = '1') then
    instr_class <= DT;
elsif(instruction(27 downto 26) = "00") then
    instr_class <= DP;
elsif(instruction(27 downto 26)="10") then
    instr_class <= BRN;
else
    instr_class <= none;
end if;


-- load_store <= load when instruction (20) = '1' else store;
-- load_store<= 
-- ldr when instruction(20)='1' and instruction(22)='0',
-- str when instruction(20)='0' and instruction(22)='0',

-- ldrb when instruction(20)='1' and instruction(22)='1',
-- strb when instruction(20)='0' and instruction(22)='1',

-- strh when instruction(20)='0' and instruction(6 downto 5)="01",
-- ldrh when instruction(20)='1' and instruction(6 downto 5)="01",
-- ldrsb when instruction(20)='1' and instruction(6 downto 5)="10",
-- ldrsh when instruction(20)='1' and instruction(6 downto 5)="11";

end process;

end Behavioral;
library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

entity gluecode is 
port(
    clock,reset: in std_logic);
end gluecode;

architecture glue_arch of gluecode is 
component fsm_new
port(
    clock: in std_logic;
    instr_class: in instr_class_type;
    opcode: in std_logic_vector(3 downto 0);
    DT_offset_sign: in DT_offset_sign_type;
    DP_operand_src : in DP_operand_src_type;
    cond_checker_output: in std_logic;
    load_store : in load_store_type;

    fsm_opcode: out std_logic_vector(3 downto 0);
    PW, IorD, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1, ReW, F_set: out std_logic;
    Asrc2: out std_logic_vector(1 downto 0)
    );
    end component;
-- -------------------------------------------------------------------------------------------------------------------
component alu_io 
port(
    operand1 :in std_logic_vector(31 downto 0);
    operand2 :in std_logic_vector(31 downto 0);
    carryin :in std_logic;
    opcode :in std_logic_vector(3 downto 0);
    carryout, msb_oper1, msb_oper2 : out std_logic;
    result :out std_logic_vector(31 downto 0)
    );
end component;

-- ----------------------------------------------------------- --------------------------------------------------------
component rf_io
port(
    rad1,rad2,wad: in std_logic_vector(3 downto 0);
    rf_write_enable: in std_logic;
    clock: in std_logic;
    rd1,rd2: out std_logic_vector(31 downto 0);
    wd:in std_logic_vector(31 downto 0)
    );
    end component;
 
-- ----------------------------------------------------------- --------------------------------------------------------
component mem_io is 
port(
    mem_ad: in std_logic_vector(5 downto 0);--6 bit write add or write
    mem_wd:  in std_logic_vector(31 downto 0);--32 bit word to write in mem_wadd
    mem_rd: out std_logic_vector(31 downto 0);--read output
    clock,IorD: in std_logic;--0 for I , 1 for D
    mem_write_enable: in std_logic_vector(3 downto 0)
);
    end component;    
    signal mem_ad: std_logic_vector(5 downto 0):=(others=>'0');
    signal mem_wd : std_logic_vector(31 downto 0);
    signal mem_rd  : std_logic_vector(31 downto 0);
    --signal clock: std_logic:='0';
    signal IorD : std_logic:='0';
    signal mem_write_enable: std_logic_vector(3 downto 0):=(others=>'0');
-- ----------------------------------------------------------- done --------------------------------------------------------

-- ----------------------------------------------------------- --------------------------------------------------------
component pc_io 
port(
    pc_in:                  in std_logic_vector(31 downto 0);
    pc_out:                 out std_logic_vector(31 downto 0);
    clock,reset:            in std_logic 
);
end component;
-- ----------------------------------------------------------- --------------------------------------------------------
component flag  
port(
    instr_class: in instr_class_type;
    DP_subclass : in DP_subclass_type;
    instruction : in std_logic_vector(31 downto 0);
    clk: in std_logic;
    s_bit: in std_logic;				--set flags if s=1 else not
    -- shift/rotate
    shift_rot: in std_logic:='0';
    c_out : in std_logic;				-- carry from alu
    -- c_out from shifter
    shift_carry: in std_logic:='0';
    result: in std_logic_vector(31 downto 0);
    msb_oper1: in std_logic;
    msb_oper2: in std_logic;
    Z, N, C, V: out std_logic;
    F_set: in std_logic
);
end component;
-- ----------------------------------------------------------- --------------------------------------------------------
component Decoder is 
Port (
    instruction : in  word;
    instr_class : out  instr_class_type;
    operation : out  std_logic_vector(3 downto 0);
    DP_subclass : out DP_subclass_type;
    DP_operand_src : out DP_operand_src_type;
    load_store : out load_store_type;
    DT_offset_sign : out DT_offset_sign_type;
    radd1: out std_logic_vector(3 downto 0);
    condition: out std_logic_vector(3 downto 0);
    branch_offset: out std_logic_vector(23 downto 0)
    );
end component;
-- ----------------------------------------------------------- --------------------------------------------------------
component cond_check is
    port(
        Z,C,N,V: in std_logic;
        condition: in std_logic_vector(3 downto 0);
        cond_checker_output: out std_logic
    );
    end component;

-- ----------

  
signal rad1, rad2, wad: std_logic_vector(3 downto 0):=(others=>'0');
signal rf_write_enable: std_logic:='0';
signal rd1, rd2: std_logic_vector(31 downto 0):=(others=>'0');
signal wd :std_logic_vector(31 downto 0):=(others=>'0');

signal operand1,operand2 :std_logic_vector(31 downto 0);
signal carryin: std_logic;
signal opcode :std_logic_vector(3 downto 0):= (others => '0');
signal carryout: std_logic;
signal msb_oper1: std_logic;
signal msb_oper2: std_logic;
signal result: std_logic_vector(31 downto 0);

signal cond_checker_output : std_logic:='0';
signal condition: std_logic_vector (3 downto 0):=(others=>'0');

signal DP_operand_src :  DP_operand_src_type;
signal load_store : load_store_type;
signal DT_offset_sign : DT_offset_sign_type;
signal radd1: std_logic_vector(3 downto 0);
signal operation :  std_logic_vector(3 downto 0);

signal instr_class: instr_class_type;
signal DP_subclass : DP_subclass_type;
--signal instruction : std_logic_vector(31 downto 0);
signal s_bit: std_logic := '0';
signal c_out: std_logic := '1';
signal Z, N, C, V,shift_rot,shift_carry: std_logic;

signal pc_in : std_logic_vector(31 downto 0):=(others=>'0');
signal instr : std_logic_vector(31 downto 0):=(others=>'0');
signal pc_out : std_logic_vector(31 downto 0);
signal cond_check_op: std_logic;
signal branch_offset: std_logic_vector(23 downto 0);


signal fsm_opcode: std_logic_vector(3 downto 0);
signal    PW, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1, ReW, F_set: std_logic;
signal    Asrc2: std_logic_vector(1 downto 0);
-- ---------------------------------------------

signal a, b, ir, dr, res: std_logic_vector(31 downto 0):=X"00000000";

--signal clock: std_logic;
begin 
fsm: fsm_new port map(clock,instr_class,opcode,DT_offset_sign,DP_operand_src,cond_checker_output,load_store,shift_src,fsm_opcode,PW,IorD,MW,IW,DW,M2R,RSRC,RSRC1,BW,RW,AW,ASRC1,REW,F_SET,SAW,SReW,ASRC2,SAM,SVM);
alu: alu_io port map(operand1,operand2,carryin,fsm_opcode,carryout,msb_oper1,msb_oper2,result);

dm : mem_io port map (mem_ad , mem_wd, mem_rd , clock ,IorD, mem_write_enable);
rf: rf_io port map(rad1,rad2,wad,rf_write_enable,clock,rd1,rd2,wd);
dec: Decoder port map(ir, instr_class, opcode, DP_subclass, DP_operand_src,
load_store, DT_offset_sign, rad1, condition,branch_offset);
pc : pc_io port map(pc_in, pc_out, clock,reset);
flg:  flag port map (instr_class, DP_subclass,ir, clock,s_bit,shift_rot,carryout,shift_carry,result,msb_oper1,msb_oper2,Z,N,C,V,f_set);
condch: cond_check port map(Z,C,N,V, condition, cond_checker_output);


process(pc_out,C,carryout,rd1,result,rd2,clock,reset,a, b, ir, dr, res,PW, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1,Asrc2, ReW, F_set)
begin
rad1<=ir(19 downto 16);
wad<=ir(15 downto 12);
mem_wd<=b;
if(IW='1') then
    ir<= mem_rd;
    end if;
if(DW='1') then 
    dr<=mem_rd;
    end if;
if(AW='1' ) then
    a<=rd1;
    end if;
if(BW='1') then
    b<=rd2;
    end if;
if(ReW='1') then
    res<=result;
    end if;
if(PW='1') then 
    pc_in<=result(29 downto 0)&"00";
    end if;
if(MW='1') then 
    mem_write_enable<="1111";
else mem_write_enable<="0000";
    end if;
if(M2R='1') then 
    wd<=dr;
else wd<=res;
    end if;
if(Rsrc='0') then 
    rad2<= ir(3 downto 0);
else rad2<=ir(15 downto 12); 
    end if;
if(IorD='0') then 
    mem_ad<=pc_out(7 downto 2);
else mem_ad<=res(5 downto 0);
    end if;
if(RW='1') then 
    rf_write_enable<='1';
else rf_write_enable<='0';
    end if;
if(Asrc1='0') then
    operand1<="00" & pc_out(31 downto 2);
else operand1<=a;
end if;
if(Asrc2="00") then 
    operand2<=b;
elsif(Asrc2="01") then 
    operand2<=X"00000001";
elsif(Asrc2="10") then
    operand2<="00000000000000000000" & ir(11 downto 0);
else operand2<="00000000"& branch_offset; --word offset;
end if;
if(Asrc2="11") then carryin<='1';
else carryin<=C;
end if;
if(instr_class=DP and  ir(20)='1') then s_bit<='1'; 
else s_bit<='0';
end if ;

end process;
end glue_arch;


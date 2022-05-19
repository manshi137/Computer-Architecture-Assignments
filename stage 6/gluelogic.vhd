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
        clock, abc: in std_logic;
        instr_class: in instr_class_type;
        opcode: in std_logic_vector(3 downto 0);
        DT_offset_sign: in DT_offset_sign_type;
        DP_operand_src : in DP_operand_src_type;
        cond_checker_output: in std_logic;
        load_store : in load_store_type;
        shift_src: in shift_src_type;
        fsm_opcode: out std_logic_vector(3 downto 0);
        PW, IorD, MW, IW, DW, M2R, Rsrc,RSRC1, BW, RW, AW, Asrc1, ReW, F_set, SAW,SReW, SVW: out std_logic;
        DT_OFFSET: in DP_operand_src_type;
        Asrc2, SAM,SVM: out std_logic_vector(1 downto 0);
        WB: out std_logic
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
component sru is
    Port (
        clock: in std_logic;
        shifttype: in shift_type;
        
        shift_amount: in std_logic_vector(4 downto 0); --shift amount
        val: in std_logic_vector(31 downto 0);
        shiftedval: out std_logic_vector(31 downto 0);
        shift_carry: out std_logic
        );
        end component;
    
component pmconnect is
    port (
        rout,mout:  in std_logic_vector(31 downto 0);
        instrn: in load_store_type;
        adr10:                  in std_logic_vector(1 downto 0);
        instr_class:            in instr_class_type;
        -- load_store:             in load_store_type;
        rin, m_in:              out std_logic_vector(31 downto 0);
        mwrite:                     out std_logic_vector(3 downto 0)
        );
    end component;
-- -------------
signal rin,m_in: std_logic_vector(31 downto 0):= X"00000000";
signal instrn: load_store_type;
signal adr10: std_logic_vector(1 downto 0);

signal rad1, rad2, wad, mwrite : std_logic_vector(3 downto 0):=(others=>'0');
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

signal DP_operand_src , DT_OFFSET:  DP_operand_src_type;
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

signal pc_in,val,shiftedval : std_logic_vector(31 downto 0):=(others=>'0');
signal instr : std_logic_vector(31 downto 0):=(others=>'0');
signal pc_out : std_logic_vector(31 downto 0);
signal cond_check_op: std_logic;
signal branch_offset: std_logic_vector(23 downto 0);


signal fsm_opcode: std_logic_vector(3 downto 0);
signal    PW, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1, ReW, F_set,SAW,SReW,Rsrc1,SVW,WB: std_logic;
signal    Asrc2,SAM,SVM: std_logic_vector(1 downto 0);
-- ---------------------------------------------
signal shifttype: shift_type;
signal shift_src: shift_src_type;
signal a, b, ir, dr, res, sres, sv: std_logic_vector(31 downto 0):=X"00000000";
signal shift_amount, sa: std_logic_vector(4 downto 0);
signal dt_shift_src_i: std_logic;
signal mem_write_enable_1: std_logic_vector(3 downto 0):= "0000";
--signal clock: std_logic;
begin 
fsm: fsm_new port map(clock, IR(22), instr_class,opcode,DT_offset_sign,DP_operand_src,cond_checker_output,load_store,shift_src,fsm_opcode,PW,IorD,MW,IW,DW,M2R,RSRC,RSRC1,BW,RW,AW,ASRC1,REW,F_SET,SAW,SReW,SVW,DT_OFFSET,ASRC2,SAM,SVM,WB);
alu: alu_io port map(operand1,operand2,carryin,fsm_opcode,carryout,msb_oper1,msb_oper2,result);

dm : mem_io port map (mem_ad , mem_wd, mem_rd , clock ,IorD, mem_write_enable);
rf: rf_io port map(rad1,rad2,wad,rf_write_enable,clock,rd1,rd2,wd);
dec: Decoder port map(ir, instr_class, opcode, DP_subclass, DP_operand_src,
load_store, DT_offset_sign, condition,branch_offset,shifttype,shift_src,DT_OFFSET);
pc : pc_io port map(pc_in, pc_out, clock,reset);
flg:  flag port map (instr_class, DP_subclass,ir, clock,s_bit,shift_rot,carryout,shift_carry,result,msb_oper1,msb_oper2,Z,N,C,V,f_set);
condch: cond_check port map(Z,C,N,V, condition, cond_checker_output);
srunit: sru port map(clock,shifttype,sa,sv,shiftedval,shift_carry);
pmc: pmconnect port map(rd2,mem_rd,load_store,adr10,instr_class,rin,M_in,mem_write_enable_1);


process(ir, b, mem_wd, IW, DW, AW, BW, rd1,rd2,
ReW, result, PW, MW, M2R, dr, res, rsrc, rad2, 
pc_out, IorD, RW, Asrc1, Asrc2, a,sres,C,N,Z,V,
instr_class, SReW, shiftedval,RSRC1,SAM, SVM, SVW, 
shift_amount, val, m_in, rin)
begin
    --old glue start 
-- rad1<=ir(19 downto 16);

-- val<= b;

mem_wd<=b;
if(IW='1') then
    ir<= mem_rd;
    end if;
if(DW='1') then 
    dr<=rin;
    end if;
if(AW='1' ) then
    a<=rd1;
    end if;
if(BW='1') then
    b<=M_in;
    end if;
if(ReW='1') then
    res<=result;
    end if;
if(PW='1') then 
    pc_in<=result(29 downto 0)&"00";
    end if;
if(MW='1') then 
    mem_write_enable<=mem_write_enable_1;
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
    adr10<=pc_out(1 downto 0);
elsif (ir(20)='0') then --post indexing
    mem_ad<=a(7 downto 2);
    adr10<=a(1 downto 0);
elsif(IR(24)='1') then mem_ad<=res(7 downto 2);
    adr10<=res(1 downto 0);
    else
        mem_ad <= a(7 downto 2);
        adr10 <= a(1 downto 0);
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
    operand2<=sres;
elsif(Asrc2="01") then 
    operand2<=X"00000001";
elsif(Asrc2="10") then
    operand2<=sres;
else 
if(ir(23)='1') then 
    operand2 <= "11111111"&IR(23 downto 0);
else
    operand2 <= "00000000"&IR(23 downto 0);
    end if;
end if;
if(Asrc2="11") then carryin<='1';
else carryin<=C;
end if;
if(instr_class=DP and  ir(20)='1') then s_bit<='1'; 
else s_bit<='0';
end if ;
-- old glue end
---------------------------------
if (SAW = '1') then 
    sa <= shift_amount;
end if;
if(SVW = '1') then
    sv <= val;
end if;

if (SReW = '1')  then
    SRES<= shiftedval;
end if ;

if(RSRC1 = '1') then 
    rad1<= ir(11 downto 8);
else rad1<= ir(19 downto 16);
end if ;

if(SAM = "00") then
    shift_amount<= rd1(4 downto 0);
    elsif(SAM="01") then
    shift_amount<= ir(11 downto 7);
    elsif(SAM="10") then 
    shift_amount<= ir(11 downto 8)&'0';
    else 
    shift_amount<= "00000";
end if;

if(SVM = "00") then 
    val<=X"000000" & IR(7 downto 0);
elsif(SVM ="01") then
    val<=rd2;
elsif(SVM<="10") then 
    val<=X"00000" & IR(11 downto 0);
else
    val <= X"000000" & IR(11 downto 8) & IR(3 downto 0);
end if;

-----------------new gluelogic----------------------------
--to choose if we have to write back or not
if(WB='1') then
    if(ir(21)='1' or ir(24)='0') then
        rf_write_enable<='1';
        wad<=ir(19 downto 16);
    end if;
        else
        rf_write_enable <= RW; 
        wad<=ir(15 downto 12);
    end if;

end process;
end glue_arch;




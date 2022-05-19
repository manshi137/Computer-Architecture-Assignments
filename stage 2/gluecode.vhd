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
    clk: in std_logic;
    rd1,rd2: out std_logic_vector(31 downto 0);
    wd:in std_logic_vector(31 downto 0)
    );
    end component;
 
-- ----------------------------------------------------------- --------------------------------------------------------
component dm_io is 
port(
    dm_wadd: in std_logic_vector(5 downto 0);--6 bit write add
    dm_wd:  in std_logic_vector(31 downto 0);--32 bit write data
    dm_rd: out std_logic_vector(31 downto 0);--32 bit read ouput
    clk: in std_logic;
    dm_write_enable: in std_logic_vector(3 downto 0);
    );
    end component;    
    signal dm_wadd: std_logic_vector(5 downto 0):=(others=>'0');
    signal dm_wd : std_logic_vector(31 downto 0);
    signal dm_rd  : std_logic_vector(31 down to 0);
    --signal clock: std_logic:='0';
    signal dm_write_enable: std_logic_vector(3 downto 0):=(others=>'0');
-- ----------------------------------------------------------- done --------------------------------------------------------
component pm_io
    port(
        pm_ad: in std_logic_vector(5 downto 0);
        pm_ins: out std_logic_vector(31 downto 0)
    );
    end component;
    signal pm_ad: std_logic_vector(5 downto 0):= (others=>'0');
    signal pm_ins: std_logic_vector(31 downto 0):= (others=>'0');
-- ----------------------------------------------------------- --------------------------------------------------------
component pc_io 
port(
    pc_in: in std_logic_vector(31 downto 0);
    pc_out: out std_logic_vector(31 downto 0);
    clk,rst: in std_logic ;
    cond_checker_output: in std_logic;
    instruction: in std_logic_vector(31 downto 0);
    offset: in std_logic_vector(23 downto 0);
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
    shift_rot: in std_logic;
    c_out : in std_logic;				-- carry from alu
    -- c_out from shifter
    shift_carry: in std_logic;
    result: in std_logic_vector(31 downto 0);
    msb_oper1: in std_logic;
    msb_oper2: in std_logic;
    Z, N, C, V: out std_logic
);
end component;
-- ----------------------------------------------------------- --------------------------------------------------------
component Decoder is 
Port (
    instruction : in  word;
    instr_class : out  instr_class_type;
    operation : out optype;
    DP_subclass : out DP_subclass_type;
    DP_operand_src : out DP_operand_src_type;
    load_store : out load_store_type;
    DT_offset_sign : out DT_offset_sign_type;
    radd1: out std_logic_vector(3 downto 0);
    condition: out std_logic_vector(3 downto 0);
    offset: out std_logic_vector(23 downto 0)
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

-- ----------------------------------------------------------- --------------------------------------------------------
   
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
signal operation : optype;

signal instr_class: instr_class_type;
signal DP_subclass : DP_subclass_type;
signal instruction : std_logic_vector(31 downto 0);
signal s_bit: std_logic := '1';
signal c_out: std_logic := '1';
signal Z, N, C, V,shift_rot,shift_carry: std_logic;

signal pc_in : std_logic_vector(31 downto 0):=(others=>'0');
signal  instr : std_logic_vector(31 downto 0):=(others=>'0');
signal pc_out : std_logic_vector(31 downto 0);
signal cond_check_op: std_logic;
signal offset: std_logic_vector(23 downto 0);
--signal clock: std_logic;
begin 
alu: alu_io port map(operand1,operand2,carryin,opcode,carryout,msb_oper1,msb_oper2,result);
pm: pm_io port map(pm_ad, pm_ins);
dm : dm_io port map (dm_wadd , dm_wd, dm_rd , clock , dm_write_enable);
rf: rf_io port map(rad1,rad2,wad,rf_write_enable,clock,rd1,rd2,wd);
dec: Decoder port map(instruction, instr_class, operation, DP_subclass, DP_operand_src,
load_store, DT_offset_sign, rad1, condition,offset);
pc : pc_io port map(pc_in, pc_out, clock,reset, cond_checker_output, instruction,offset);
flg:  flag port map (instr_class, DP_subclass,instruction, clock,s_bit,shift_rot,c_out,shift_carry,result,msb_oper1,msb_oper2,Z,N,C,V);
condch: cond_check port map(Z,C,N,V, condition, cond_checker_output);

process(instruction,pc_out,C,carryout,rd1,result,rd2,clock,reset)
begin
if(rising_edge(clock)) then
    pm_ad<= pc_out(7 downto 2);
    instruction<=pm_ins; 
    carryin<=C;
    c_out<=carryout;
    operand1<= rd1;
    dm_wadd<= result(5 downto 0);
    dm_wd<= rd2;
    -- rad2 multiplexer
    if( instr_class= DP ) then rad2<= instruction(3 downto 0);
    elsif ( instr_class =DT) then rad2<= instruction(15 downto 12); end if;

    -- alu oper2 mux
    if(instruction(25)='1') then operand2<= "00000000000000000000" & instruction(11 downto 0);
    elsif(instruction(25)='0') then operand2<= rd2; end if;
    
    -- wd in rf mux
    if(instr_class=DT) then wd <= dm_rd;
    elsif(instr_class=DP) then wd<= result; end if;
    
    -- enable for write in reg file / memory
    if(load_store=load) then 
        rf_write_enable<='1' ;
        mem_write_enable<"0000";
    elsif(load_store=store ) then 
        mem_write_enable<="1111"; 
        rf_write_enable<='0' ;
    end if;
    -- dt offset sign
    if(instr_class = DT and DT_offset_sign = plus) then opcode<="0100"; end if;
    if(instr_class=DT and DT_offset_sign=minus) then opcode<="0010"; end if;

end if ;

end process;
end glue_arch;
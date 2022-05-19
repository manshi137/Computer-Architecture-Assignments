library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

entity flag is 
    port(
        instr_class: in instr_class_type;
        DP_subclass : in DP_subclass_type;
        instruction : in std_logic_vector(31 downto 0);
        clock: in std_logic;
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
end flag ;

architecture flag_arch of flag is 
signal zzz, ccc, nnn, vvv: std_logic:='0'; 
begin
process(s_bit,clock)
	variable zz,nn,cc,vv: std_logic;
    variable msb_result:std_logic;
    variable c_31 :std_logic;
    begin
    msb_result:= result(31);
    if(rising_edge(clock)) then
    if (instr_class=DP) then 
        c_31:= msb_oper1 xor msb_oper2 xor msb_result; 	  -- calculating pre-final carry from ALU
        cc := c_31;                                       --set C flag 
        vv := c_31 xor c_out;                             --set V flag 
        if ( (DP_subclass= comp )  or(DP_subclass = test) or (DP_subclass=arith and s_bit='1') )then 
            if (result = X"00000000") then 
            zz:= '1';     								  --set Z flag if result is 0
            else zz:='0'; 
            end if;
            if (msb_result='1') then 
            nn:='1';                 					  --set N flag if msb of result is 1
            else nn:='0'; 
            end if;
            cc := c_31;                                       --set C flag 
        	vv := c_31 xor c_out;                             --set V flag 

		elsif((shift_rot='1' and s_bit ='1')) then 
        	if (result = X"00000000") then 
            	zz:= '1';     								  --set Z flag if result is 0
            	else zz:='0'; 
            	end if;
            if (msb_result='1') then 
            	nn:='1';                 					  --set N flag if msb of result = 1
            	else nn:='0'; 
            	end if;
            cc:= shift_carry;
           
            
            
            
        end if ;
    end if;
    end if;
    Z<=zz;
    N<=nn;
    C<=cc;
    V<=vv;
    zzz<=zz;
    nnn<=nn;
    ccc<=cc;
    vvv<=vv;
end process;
end flag_arch;
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
        Z, N, C, V: out std_logic;
        F_set: in std_logic
    );
end flag ;

architecture flag_arch of flag is 
signal zzz, ccc, nnn, vvv: std_logic:='0'; 
begin
process(clk)
	
    -- variable msb_result:std_logic;
    -- variable c_31 :std_logic;
    begin
    --msb_result:= result(31);
    if(rising_edge(clk) and F_set='1') then
 
        -- c_31:= msb_oper1 xor msb_oper2 xor msb_result; 	  -- calculating pre-final carry from ALU
        -- ccc := c_31;                                       --set C flag 
        -- vvv := c_31 xor c_out;                             --set V flag
        
        
    if ( (DP_subclass= comp )  )then 
        if (result = X"00000000") then 
        zzz<= '1';     								  --set Z flag if result is 0
        else zzz<='0'; 
        end if;
        if (result(31)='1') then 
        nnn<='1';                 					  --set N flag if msb of result is 1
        else nnn<='0'; 
        end if;
        ccc <= c_out;                                       --set C flag 
        vvv<= (msb_oper1 and msb_oper2 and (not result(31))) or ((not msb_oper1) and (not msb_oper2) and result(31));
        -- c_31:= msb_oper1 xor msb_oper2 xor result(31); 	  -- calculating pre-final carry from ALU
        -- vvv <= (msb_oper1 xor msb_oper2 xor result(31) ) xor c_out;--set V flag

        --    (msb_oper1 and msb_oper2 and (not result(31))) or ((not msb_oper1) and (not msb_oper2) and result(31))
    elsif (DP_subclass=arith and s_bit='1') then
        if (result = X"00000000") then 
            zzz<= '1';     								  --set Z flag if result is 0
        else zzz<='0'; 
        end if;
        if (result(31)='1') then 
            nnn<='1';                 					  --set N flag if msb of result is 1
        else nnn<='0'; 
        end if;
        ccc <= c_out;                                       --set C flag 
        vvv<= (msb_oper1 and msb_oper2 and (not result(31))) or ((not msb_oper1) and (not msb_oper2) and result(31));
        -- c_31:= msb_oper1 xor msb_oper2 xor result(31); 	  -- calculating pre-final carry from ALU
        -- vvv <= c_31 xor c_out;                             --set V flag
        -- vvv <= (msb_oper1 xor msb_oper2 xor result(31) ) xor c_out;

    elsif(DP_subclass=logic and s_bit='1' and shift_rot='0' ) then
        
            if (result = X"00000000") then 
                zzz<= '1';     								  --set Z flag if result is 0
                else zzz<='0'; 
                end if;
            if (result(31)='1') then 
                nnn<='1';                 					  --set N flag if msb of result = 1
                else nnn<='0'; 
                end if;
    elsif(DP_subclass=logic and s_bit='1' and shift_rot='1' ) then
            if (result = X"00000000") then 
                zzz<= '1';     								  --set Z flag if result is 0
                else zzz<='0'; 
                end if;
            if (result(31)='1') then 
                nnn<='1';                 					  --set N flag if msb of result = 1
                else nnn<='0'; 
                end if;
            ccc<= shift_carry;                                   --set C flag
         
    elsif((DP_subclass=logic and shift_rot='1' and s_bit ='1')) then 
            if (result = X"00000000") then 
                zzz<= '1';     								  --set Z flag if result is 0
                else zzz<='0'; 
                end if;
            if (result(31)='1') then 
                nnn<='1';                 					  --set N flag if msb of result = 1
                else nnn<='0'; 
                end if;
            ccc<= shift_carry;                                   --set C flag 
       
    
    elsif(DP_subclass = test and shift_rot='1' and s_bit ='1') then 
            if (result = X"00000000") then 
                zzz<= '1';     								  --set Z flag if result is 0
                else zzz<='0'; 
                end if;
            if (result(31)='1') then 
                nnn<='1';                 					  --set N flag if msb of result = 1
                else nnn<='0'; 
                end if;
            ccc<= shift_carry;                                   --set C flag 

    elsif(DP_subclass = test)  then
            if (result = X"00000000") then 
                zzz<= '1';     								  --set Z flag if result is 0
                else zzz<='0'; 
                end if;
            if (result(31)='1') then 
                nnn<='1';                 					  --set N flag if msb of result = 1
                else nnn<='0'; 
                end if;
   
    end if; --43
    end if;--36
    end process;
    Z<=zzz;
    N<=nnn;
    C<=ccc;
    V<=vvv;
    
    end flag_arch;
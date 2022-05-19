library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru2 is 
    port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval2: out std_logic_vector(31 downto 0)
    );
end sru2;
architecture sru2arch of sru2 is 
begin
    process(shift,val,shifttype,carryin)
    begin
    if (shift='1') then
    
        --2bitshift
            case shifttype is 
            when LSR =>
            shiftedval2<= "00" & val(31 downto 2);
            shift_carry_out<=val(0);
            when ASR=>
            if(val(31)='1') then 
            shiftedval2<= "11"&val(31 downto 2);
            else
            shiftedval2<= "00"&val(31 downto 2);
            end if;
            shift_carry_out<=val(1);
            when ROT=>
            shiftedval2<= val(1 downto 0)&val(31 downto 2);
            shift_carry_out<= val(1);
            when LSL=>
            shiftedval2<= val(29 downto 0)&"00";
            shift_carry_out<= val(30);
            end case;
        else
            shiftedval2<=val;
            shift_carry_out<=carryin;
        end if;
    end process;
    end sru2arch;


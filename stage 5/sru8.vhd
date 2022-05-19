library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru8 is 
    port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in shift_type;
        shift_carry_out: out std_logic;
        shiftedval8: out std_logic_vector(31 downto 0)
    );
end sru8;
architecture sru8arch of sru8 is 
begin
    process(shift,val,shifttype,carryin)
    begin
    if (shift='1') then
        --8bitshift
            case shifttype is 
            when LSR =>
            shiftedval8<= "00000000" & val(31 downto 8);
            shift_carry_out<=val(7);
            when ASR=>
            if(val(31)='1') then 
            shiftedval8<= "11111111"&val(31 downto 8);
            else
            shiftedval8<= "00000000"&val(31 downto 8);
            end if;
            shift_carry_out<=val(7);
            when ROT=>
            shiftedval8<= val(7 downto 0)&val(31 downto 8);
            shift_carry_out<= val(7);
            when LSL=>
            shiftedval8<= val(23 downto 0)&"00000000";
            shift_carry_out<= val(24);
            end case;
        else
            shiftedval8<=val;
            shift_carry_out<=carryin;
        end if;
    end process;
    end sru8arch; 
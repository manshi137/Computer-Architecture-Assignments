library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru4 is 
    port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval4: out std_logic_vector(31 downto 0)
    );
end sru4;
architecture sru4arch of sru4 is 
begin
    process(shift,val,shifttype,carryin)
    begin
    if (shift='1') then
        --4bitshift
            case shifttype is 
            when LSR =>
            shiftedval4<= "0000" & val(31 downto 4);
            shift_carry_out<=val(3);
            when ASR =>
            if(val(31)='1') then 
            shiftedval4<= "1111"&val(31 downto 4);
            else
            shiftedval4<= "0000"&val(31 downto 4);
            end if;
            shift_carry_out<=val(3);
            when ROT=>
            shiftedval4<= val(3 downto 0)&val(31 downto 4);
            shift_carry_out<= val(3);
            when LSL=>
            shiftedval4<= val(27 downto 0)&"0000";
            shift_carry_out<= val(28);
            end case;
        else
            shiftedval4<=val;
            shift_carry_out<=carryin;
        end if;
  end process;
  end sru4arch;
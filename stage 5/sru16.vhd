library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru16 is 
    port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in shift_type;
        shift_carry_out: out std_logic;
        shiftedval16: out std_logic_vector(31 downto 0)
    );
end sru16;
architecture sru16arch of sru16 is 
begin
    process(shift,val,shifttype,carryin)
    begin
    if (shift='1') then
        --16bitshift
            case shifttype is 
            when LSR =>
            shiftedval16<= "0000000000000000" & val(31 downto 16);
            shift_carry_out<=val(15);
            when ASR=>
            if(val(31)='1') then 
            shiftedval16<= "1111111111111111"&val(31 downto 16);
            else
            shiftedval16<= "0000000000000000"&val(31 downto 16);
            end if;
            shift_carry_out<=val(15);
            when ROT=>
            shiftedval16<= val(15 downto 0)&val(31 downto 16);
            shift_carry_out<= val(15);
            when LSL=>
            shiftedval16<= val(15 downto 0)&"0000000000000000";
            shift_carry_out<= val(16);
            end case;
        else
            shiftedval16<=val;
            shift_carry_out<=carryin;
        end if;

    end process;
    end sru16arch;
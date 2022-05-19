library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru1 is 
    port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in shift_type;
        shift_carry_out: out std_logic;
        shiftedval1: out std_logic_vector(31 downto 0)
    );
end sru1;
architecture sru1arch of sru1 is 
begin
    process(shift,val,shifttype,carryin)
    begin
    if (shift='1') then
        --1bitshift
            case shifttype is 
            when LSR =>
            shiftedval1<= '0'& val(31 downto 1);
            shift_carry_out<=val(0);
            when ASR=>
            shiftedval1<= val(31)&val(31 downto 1);
            shift_carry_out<=val(0);
            when ROT=>
            shiftedval1<= val(0)&val(31 downto 1);
            shift_carry_out<= val(0);
            when LSL=>
            shiftedval1<= val(30 downto 0)&'0';
            shift_carry_out<= val(31);
            end case;
        else
            shiftedval1<=val;
            shift_carry_out<=carryin;
        end if;
    end process;
    end sru1arch;
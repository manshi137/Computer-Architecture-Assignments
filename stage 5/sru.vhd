library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity sru is
    Port (
        clock: in std_logic;
        shifttype: in shift_type;
        shift_amount: in std_logic_vector(4 downto 0); --shift amount
        val: in std_logic_vector(31 downto 0);
        shiftedval: out std_logic_vector(31 downto 0);
        shift_carry: out std_logic
        );
        end sru;
        
architecture sru_arch of sru is
    component sru1 is
        port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval1: out std_logic_vector(31 downto 0)
    );
        end component;
    component sru2 is
        port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval2: out std_logic_vector(31 downto 0)
    );
        end component;
    component sru4 is
        port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval4: out std_logic_vector(31 downto 0)
    );
        end component;
    component sru8 is
        port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval8: out std_logic_vector(31 downto 0)
    );
        end component;
    component sru16 is
        port (
        shift: in std_logic;
        carryin: in std_logic;
        val: in std_logic_vector(31 downto 0);
        shifttype: in Shift_type;
        shift_carry_out: out std_logic;
        shiftedval16: out std_logic_vector(31 downto 0)
    );
        end component;
        
    signal shiftedval1, shiftedval2, shiftedval4, shiftedval8, shiftedval16: std_logic_vector(31 downto 0);
    signal carry1,carry2,carry3,carry4,carry5:std_logic;
    begin
    s1:sru1 port map(shift_amount(0),'0',val,shifttype,carry1,shiftedval1);
    s2:sru2 port map(shift_amount(1),carry1,shiftedval1,shifttype,carry2,shiftedval2);
    s4:sru4 port map(shift_amount(2),carry2,shiftedval2,shifttype,carry3,shiftedval4);
    s8:sru8 port map(shift_amount(3),carry3,shiftedval4,shifttype,carry4,shiftedval8);
    s16:sru16 port map(shift_amount(4),carry4,shiftedval8,shifttype,carry5,shiftedval16);

        process(clock)
        begin
        if(rising_edge(clock)) then
        shiftedval<=shiftedval16;
        shift_carry<=carry5;
        end if;
        end process;
end sru_arch;


        
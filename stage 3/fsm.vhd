library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

entity fsm_new is 
    --generic (clockfreq: integer);
    port(
        clock: in std_logic;
        instr_class: in instr_class_type;
        opcode: in std_logic_vector(3 downto 0);
        DT_offset_sign: in DT_offset_sign_type;
        DP_operand_src : in DP_operand_src_type;
        cond_checker_output: in std_logic;
        load_store : in load_store_type;

        fsm_opcode: out std_logic_vector(3 downto 0);
        PW, IorD, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1, ReW, F_set: out std_logic;
        Asrc2: out std_logic_vector(1 downto 0)
        );
end fsm_new;
architecture fsm_arch of fsm_new is 

signal state: std_logic_vector(3 downto 0):="0001";
    
begin 
    process(clock)
    begin
    if(rising_edge(clock)) then
        if(state="0001") then 
            PW<='1';
            IorD<='0';
            IW<='1';
            fsm_opcode<="0100"; --add
            ASRC1<='0';     --oper1 = pc_out word address
            ASRC2<="01";    --oper2 = 1
            state<="0010";

            MW<='0';
            DW<='0';
            M2R<='0';
            RSRC<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            state<="0010";

        elsif(state="0010") then 
            AW<='1';
            BW<='1';
            
            PW<='0';
            IorD<='0';
            MW<='0';
            IW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            ASRC1<='0';
            ASRC2<="00";
            ReW<='0';
            F_set<='0';
            if(instr_class=DP) then 
                state<="0011";
                RSRC<='0';
            elsif(instr_class=DT) then 
                state<="0100";
                RSRC<='1';
            else state<="0101"; RSRC<='1';
            end if;

        elsif(state="0011") then 
            ReW<='1';
            F_set<='1';
            ASRC1<='1';
            fsm_opcode<=opcode;
            if(DP_operand_src=reg) then Asrc2<="00";
            else Asrc2<="10";
            end if;
            RSRC<='0';---------

            BW<='0';
            AW<='0';
            PW<='0';
            IorD<='0';
            MW<='0';
            IW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            state<="0110";

        elsif(state="0100") then 
            ReW<='1';
            ASRC1<='1';
            ASRC2<="10";
            RW<='0';
            RSRC<='1';
            if(DT_offset_sign=plus) then fsm_opcode<="0100";
            else fsm_opcode<="0010";end if;

            PW<='0';
            IorD<='0';
            IW<='0';
            MW<='0';
            DW<='0';
            M2R<='0';
            AW<='0';
            BW<='0';
            F_set<='0';
            if(load_store=load) then state<="1000";
            else state<="0111";
            end if;

        elsif(state="0101") then 
            if(cond_checker_output='1') then PW<='1'; 
                else PW<='0';
                end if;
            ASRC1<='0';
            ASRC2<="11";
            IorD<='0';
            RSRC<='1';
            fsm_opcode<="0101";

            IW<='0';
            MW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            state<="0001";

        elsif(state="0110") then 
            RW<='1';
            M2R<='0';
            RSRC<='0';

            ReW<='0';
            PW<='0';
            IorD<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            MW<='0';
            DW<='0';
            AW<='0';
            BW<='0';
            F_set<='0';
            state<="0001";

        elsif(state="0111") then 
            MW<='1';
            IorD<='1';
            RSRC<='1';

            PW<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            DW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            state<="0001";

        elsif(state="1000") then 
            DW<='1';
            IorD<='1';
            RSRC<='1';

            PW<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            MW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            state<= "1001";

        elsif(state="1001") then 
            RW<='1';
            M2R<='1';
            RSRC<='1';

            PW<='0';
            IorD<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            MW<='0';
            DW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            state<="0001";

    end if;
    end if;
    end process;
    end fsm_arch;
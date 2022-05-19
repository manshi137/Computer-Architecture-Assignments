library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

entity fsm_new is 
    --generic (clockfreq: integer);
    port(
        clock, abc: in std_logic;
        instr_class: in instr_class_type;
        opcode: in std_logic_vector(3 downto 0);
        DT_offset_sign: in DT_offset_sign_type;
        DP_operand_src : in DP_operand_src_type;
        cond_checker_output: in std_logic;
        load_store : in load_store_type;
        shift_src: in shift_src_type;
        fsm_opcode: out std_logic_vector(3 downto 0);
        PW, IorD, MW, IW, DW, M2R, Rsrc,RSRC1, BW, RW, AW, Asrc1, ReW, F_set, SAW,SReW, SVW: out std_logic;
        DT_OFFSET: in DP_operand_src_type;
        Asrc2, SAM,SVM: out std_logic_vector(1 downto 0);
        WB: out std_logic
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

            SAM<="00";
            SVM<="00";
            SVW <= '0';
            RSRC1 <=  '0';
            MW<='0';
            DW<='0';
            M2R<='0';
            RSRC<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            WB<='0';
            
            state<="0010";

        elsif(state="0010") then 
            AW<='1';
            BW<='1';
            
            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            PW<='0';
            IorD<='0';
            MW<='0';
            IW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            SVW <= '0';
            ASRC1<='0';
            ASRC2<="00";
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            if(instr_class=BRN ) then 
                state<="0101";
                RSRC <= '1';
            else
                state<= "1010";
                if (instr_class= Dp) then 
                    RSRC <= '0';
                else 
                    RSRC <= '1';
                end if;
            end if;
            -- shift state 10
            -- if(instr_class=DP) then 
            --     state<="0011";
            --     RSRC<='0';
            -- elsif(instr_class=DT) then 
            --     state<="0100";
            --     RSRC<='1';
            -- else state<="0101"; RSRC<='1';
            -- end if;
            WB<='0';


        elsif(state="0011") then 
            ReW<='1';
            F_set<='1';
            ASRC1<='1';
            fsm_opcode<=opcode;
            if(DP_operand_src=reg) then Asrc2<="00";
            else Asrc2<="10";
            end if;
            RSRC<='0';
            ---------
            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            SVW <= '0';
            BW<='0';
            AW<='0';
            PW<='0';
            IorD<='0';
            MW<='0';
            IW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            SReW<='0';
            SAW<= '0';
            WB<='0';

            
            state<="0110";

        elsif(state="0100") then 
            ReW<='1';
            ASRC1<='1';
            if (DT_OFFSET = reg) then 
                ASRC2 <= "00";
            else 
                ASRC2 <= "10";
            end if;
            RW<='0';
            RSRC<='1';
            if(DT_offset_sign=plus) then fsm_opcode<="0100";
            else fsm_opcode<="0010";end if;

            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            PW<='0';
            IorD<='0';
            IW<='0';
            MW<='0';
            SVW <= '0';
            DW<='0';
            M2R<='0';
            AW<='0';
            BW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            SReW<='0';
            WB<='0';

            
            
            if(load_store= ldr or load_store = ldrb or  load_store = ldrh or  load_store = ldrsb or  load_store = ldrsh) then state<="1000";
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

            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            IW<='0';
            SVW <= '0';
            MW<='0';
            DW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            WB<='0';
            
            state<="0001";

        elsif(state="0110") then 
        	if(opcode="1000" or opcode="1001" or opcode="1010" or opcode="1011") then
            	RW <= '0';
            else 
            	RW<='1';
            end if;
            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
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
            SVW <= '0';
            BW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            WB<='0';

            
            state<="0001";

        elsif(state="0111") then 
            MW<='1';
            IorD<='1';
            RSRC<='1';

            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            PW<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            DW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            SVW <= '0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            WB<='1';

            
            state<="0001";

        elsif(state="1000") then 
            DW<='1';
            IorD<='1';
            RSRC<='1';
            
            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            PW<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            SVW <= '0';
            MW<='0';
            M2R<='0';
            RW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            WB<='1';

            
            state<= "1001";

        elsif(state="1001") then 
            RW<='1';
            M2R<='1';
            RSRC<='1';

            SAM<="00";
            SVM<="00";
            RSRC1 <=  '0';
            PW<='0';
            IorD<='0';
            IW<='0';
            ASRC1<='0';
            ASRC2<="00";
            SVW <= '0';
            MW<='0';
            DW<='0';
            AW<='0';
            BW<='0';
            ReW<='0';
            F_set<='0';
            SReW<='0';
            SAW<= '0';
            SVW <= '0';
            WB<='0';

            state<="0001";
        
        elsif(state = "1010") then --additional state1 for shift rotate
        -- store shift amount in reg rs using rad1
            SAW<= '1';--store shift amount in reg sa
            SVW <= '1';
            -- RSRC1 <=  '1';
            if(instr_class=DP and DP_operand_src=reg) then 
                SVM<="01";
                if(shift_src=reg) then
                    SAM<="00";
                    RSRC1<='1';
                else
                    SAM<="01";
                end if;
            elsif(instr_class=DP and DP_operand_src=imm) then
                SAM<="10";
                SVM<="00";
                ----shiftdataa
            elsif(instr_class=DT ) then --dt case b 
                if(DT_OFFSET=reg) then
                    SVM<="01";
                    if(shift_src=reg) then
                        SAM<="00";
                        RSRC1<='1';
                    else
                        SAM<="01";
                    end if;
                else 
                    if (load_store = ldr or load_store = str or load_store = strb or load_store = ldrb) then
                        SAM<="11";
                        SVM<="10";
                    elsif(abc = '1') then
                        SAM <= "11";
                        SVM <= "11";
                    else
                        SAM <= "11";
                        SVM <= "01";
                    end if ;
                end if;
            else --dt case a
                SAM<="11";
                SVM<="10";
            end if;

            RSRC<= '0';
            SReW<='0';
            RW<='0';
            M2R<='0';
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
            WB<='0';

            state<="1011";
        elsif (state ="1011") then --additional state2 for shift rotate
        -- store shifted value in reg sres
        SReW<='1';
         
        RSRC1 <=  '0';  --????????????/
        SAM<="00";
        SVM<="00";
        SAW<= '0';
        RW<='0';
        M2R<='0';
        RSRC<='0';
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
        if(instr_class=DP) then 
            state<="0011";
            RSRC<='0';
        elsif(instr_class=DT) then 
            state<="0100";
            RSRC<='1';
        end if;
        WB<='0';

    end if;
    end if;
    end process;
    end fsm_arch;
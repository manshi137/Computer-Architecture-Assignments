library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity pmconnect is 
    port (
        rout,mout:  in std_logic_vector(31 downto 0);
        instrn: in load_store_type;
        adr10:                  in std_logic_vector(1 downto 0);
        instr_class:            in instr_class_type;
        -- load_store:             in load_store_type;
        rin, m_in:              out std_logic_vector(31 downto 0);
        mwrite:                     out std_logic_vector(3 downto 0)
        );
end pmconnect;
architecture pmconnectarch of pmconnect is 
begin
    process(rout,instrn,mout)
    begin
        if (instrn = str and ard10="00") then 
            --store full word
            m_in(7 downto 0)<= rout(7 downto 0);
            m_in(15 downto 8)<= rout(15 downto 8);
            m_in(23 downto 16)<= rout(23 downto 16);
            m_in(31 downto 24)<= rout(31 downto 24);
            mwrite<="1111";
        elsif (instrn = strh ) then 
            --store half word
            m_in(7 downto 0)<= rout(7 downto 0);
            m_in(15 downto 8)<= rout(15 downto 8);
            m_in(23 downto 16)<= rout(7 downto 0);
            m_in(31 downto 24)<= rout(15 downto 8);
            if(adr10="00") then
                mwrite<="0011";
            elsif(adr10="10") then 
                mwrite<="1100";
            end if;
        elsif (instrn = strb ) then  
            --store one byte
            m_in(7 downto 0)<= rout(7 downto 0);
            m_in(15 downto 8)<= rout(7 downto 0);
            m_in(23 downto 16)<= rout(7 downto 0);
            m_in(31 downto 24)<= rout(7 downto 0);
            if(adr10="00") then
                mwrite<="0001";
            elsif(adr10="01") then 
                mwrite<="0010";
            elsif(adr10="10") then 
                mwrite<="0100";
            elsif(adr10="11") then 
                mwrite<="1000";
            end if;

        elsif (instrn = ldr and adr10="00") then
            rin(7 downto 0)<= mout(7 downto 0);
            rin(15 downto 8)<= mout(15 downto 8);
            rin(23 downto 16)<= mout(23 downto 16);
            rin(31 downto 24)<= mout(31 downto 24);

        elsif (instrn = ldrh) then
            rin(23 downto 16)<= X"00";
            rin(31 downto 24)<= X"00";
            if (adr10 = "00") then
                rin(7 downto 0)<= mout(7 downto 0);
                rin(15 downto 8)<= mout(15 downto 8);  
            elsif( adr10="10") then
                rin(7 downto 0)<= mout(23 downto 16);
                rin(15 downto 8)<= mout(31 downto 24);
            end if ;

        elsif( instrn = ldrsh) then 
            if (adr10 = "00") then
                rin(7 downto 0)<= mout(7 downto 0);
                rin(15 downto 8)<= mout(15 downto 8); 
                if(mout(15)='0') then 
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                else
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if; 
            elsif( adr10="10") then
                rin(7 downto 0)<= mout(23 downto 16);
                rin(15 downto 8)<= mout(31 downto 24);
                if(mout(31)='0') then 
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                else
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if; 
            end if ;

        elsif (instrn = ldrb) then
            rin(15 downto 8)<= X"00";
            rin(23 downto 16)<= X"00";
            rin(31 downto 24)<= X"00";
            if (adr10="00") then
                rin(7 downto 0)<=mout(7 downto 0 );
            elsif(adr10="01") then
                rin(7 downto 0)<=mout(15 downto 8);
            elsif(adr10="10") then
                rin(7 downto 0)<=mout(23 downto 16);
            elsif(adr10="11") then    
                rin(7 downto 0)<=mout(31 downto 24 );
            end if ;  

        elsif (instrn = ldrsb) then
            if (adr10="00") then
                rin(7 downto 0)<=mout(7 downto 0 );
                if(mout(7)='0') then 
                    rin(7 downto 0)<=X"00";
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                
                else
                    rin(7 downto 0)<="11111111";
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if;
            elsif(adr10="01") then
                rin(7 downto 0)<=mout(15 downto 8);
                if(mout(15)='0') then 
                    rin(7 downto 0)<=X"00";
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                else
                    rin(7 downto 0)<="11111111";
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if;
            elsif(adr10="10") then
                rin(7 downto 0)<=mout(23 downto 16);
                if(mout(23)='0') then 
                    rin(7 downto 0)<=X"00";
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                else
                    rin(7 downto 0)<="11111111";
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if;
            elsif(adr10="11") then    
                rin(7 downto 0)<=mout(31 downto 24 );
                if(mout(31)='0') then 
                    rin(7 downto 0)<=X"00";
                    rin(23 downto 16)<= X"00";
                    rin(31 downto 24)<= X"00";
                else
                    rin(7 downto 0)<="11111111";
                    rin(23 downto 16)<="11111111";
                    rin(31 downto 24)<= "11111111";
                end if;
            end if ;
        end if;
        end process;
        end pmconnectarch;
    
    
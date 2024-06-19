library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ControlUnit is
    port(
        clk: in std_logic;
        rst: in std_logic;
        st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
        orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: in std_logic;
        -- Control signals for the datapath
        Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in : out std_logic;
        PCsel, Rfaddr: out std_logic_vector(1 downto 0);
        OPC: out std_logic_vector(3 downto 0);
        done_FSM: out std_logic
    );
end ControlUnit;

architecture behavioral of ControlUnit is
    type state_type is (Fetch, Decode, Execute, Memory, WriteBack);
    signal current_state, next_state: state_type;

begin

    -- State transition process
    process(clk, rst)
    begin
        if rst = '1' then
            Mem_wr <= '0';
            Mem_out <= '0';
            Mem_in <= '0';
            Cout <= '0';
            Cin <= '0';
            Ain <= '0';
            RFin <= '0';
            RFout <= '0';
            IRin <= '0';
            PCin <= '0';
            Imm1_in <= '0';
            Imm2_in <= '0';
            PCsel <= "00";  -- zero initially
            Rfaddr <= "11";
            OPC <= "0000";
            current_state <= Fetch;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4) -- Moore machine
    variable RType, JtYPE, IType : std_logic; 

    begin
        RType := add or sub or andf or orf or xorf;
        JType := jmp or (jc and Cflag) or (jnc and not Cflag);
        IType := mov or ld or st or done;

        case current_state is
            when Fetch =>
                Mem_wr <= '0';
                Mem_out <= '0';
                Mem_in <= '0';
                Cout <= '0';
                Cin <= '0';
                Ain <= '0';
                RFin <= '0';
                RFout <= '0';
                IRin <= '1'; -- IR
                PCin <= '0'; 
                Imm1_in <= '0';
                Imm2_in <= '0';
                Rfaddr <= "11"; 
                OPC <= "0000";
                PCsel <= "00"; -- PC + 1
                next_state <= Decode;

            when Decode =>
                Mem_wr <= '0';
                Mem_out <= '0';
                Mem_in <= '0';
                Cout <= '0';
                Cin <= '0';
                Ain <= '0';
                RFin <= '0';
                RFout <= '0';
                IRin <= '0';
                PCin <= '0'; 
                Imm1_in <= '0';
                Imm2_in <= '0';
                Rfaddr <= "00"; -- rc
                OPC <= "0000";
                -- 00 for R-Type, 01 for J-Type, 10 for I-Type
                if (RType = '1') then
                    PCsel <= "00"; -- PC + 1
                elsif (JType = '1') then
                    PCsel <= "01"; -- pc + 1 + imm
                elsif (IType = '1') then
                    PCsel <= "10"; -- pc + 1 + imm
                end if;

                if (add or sub) then
                    Ain <= '1'; -- rc to ALU
                    RFout <= '1'; -- rc to fabric
                end if;

                if RType = '1' then
                    next_state <= Execute;
                elsif IType = '1' then
                    next_state <= Memory;
                elsif JType = '1' then
                    next_state <= Fetch;
                end if;

            when Execute =>
                Mem_wr <= '0';
                Mem_out <= '0';
                Mem_in <= '0';
                Cout <= '0';
                Cin <= '1';
                Ain <= '0'; 
                RFin <= '0';
                RFout <= '1'; -- RF read
                IRin <= '0';
                PCin <= '0'; 
                Imm1_in <= '0';
                Imm2_in <= '0';
                Rfaddr <= "01"; -- rb
                OPC <= "0000" when add='1' else
                       "0001" when sub='1' else
                       "0010" when andf='1' else
                       "0011" when orf='1' else
                       "0100" when xorf='1' else
                       "0000" when others;
                -- 00 for R-Type, 01 for J-Type, 10 for I-Type
                if (RType = '1') then
                    PCsel <= "00"; -- PC + 1
                elsif (JType = '1') then
                    PCsel <= "01"; -- pc + 1 + imm
                elsif (IType = '1') then
                    PCsel <= "10"; -- pc + 1 + imm
                end if;
                next_state <= WriteBack;

            when Memory =>
                case Status is
                    when "0010" => -- LOAD instruction
                        Mem_out <= '1';
                        Mem_in <= '1';
                        RFout <= '1';
                        next_state <= WriteBack;
                    when "0011" => -- STORE instruction
                        Mem_wr <= '1';
                        next_state <= Fetch;
                    when others =>
                        next_state <= Fetch;
                end case;

            when WriteBack =>
                Mem_wr <= '0';
                Mem_out <= '0';
                Mem_in <= '0';
                Cout <= '1';
                Cin <= '0';
                Ain <= '0'; 
                RFin <= '1'; -- RF write
                RFout <= '0'; 
                IRin <= '0';
                PCin <= '0'; 
                Imm1_in <= '0';
                Imm2_in <= '0';
                Rfaddr <= "10"; -- ra
                OPC <= "0000";
                PCsel <= "00"; -- PC + 1
                next_state <= Fetch;

            when others =>
                next_state <= Fetch;
        end case;
    end process;
end behavioral;

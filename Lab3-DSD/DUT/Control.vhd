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
    type state_type is (Reset, Fetch, Decode, Execute, Memory, WriteBack);
    signal current_state, next_state: state_type;

begin

    -- State transition process
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= Reset;
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
            when Reset =>
                if (done='1') then 
                    Mem_wr <= '0';
                    Mem_out <= '0';
                    Mem_in <= '0';
                    Cout <= '0';
                    Cin <= '0';
                    Ain <= '0';
                    RFin <= '0';
                    RFout <= '0';
                    IRin <= '0';
                    PCin <= '1';
                    Imm1_in <= '0';
                    Imm2_in <= '0';
                    Rfaddr <= "11";
                    OPC <= "0000";
                    PCsel <= "10"; -- PC <- 0
                    next_state <= Fetch;
                end if;

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
                    if (Cflag = '1' and jc = '1') then 
                        PCsel <= "01"; -- pc + 1 + imm
                    elsif (Cflag = '0' and jnc = '1') then
                        PCsel <= "01"; -- pc + 1 + imm
                    elsif (jmp = '1') then
                        PCsel <= "01"; -- pc + 1 + imm
                    else
                        PCsel <= "00"; -- PC + 1
                    end if;

                elsif (IType = '1') then
                    if (mov = '1') then
                        Imm1_in <= '1';
                    elsif (ld = '1' or st = '1') then
                        Imm2_in <= '1';
                    end if;
                    PCsel <= "00"; -- pc + 1
                end if;

                if (add = '1' or sub = '1') then
                    Ain <= '1'; -- rc to ALU
                    RFout <= '1'; -- rc to fabric
                end if;

                if RType = '1' then
                    next_state <= Execute;

                elsif IType = '1' then
                    if (mov = '1') then
                        next_state <= WriteBack;
                    elsif (ld = '1' or st = '1') then
                        Ain <= '1'; -- imm to ALU
                        RFout <= '1'; -- imm to fabric
                        next_state <= Execute;
                    elsif (done = '1') then
                        PCin <= '1';
                        done_FSM <= '1';
                        next_state <= Reset;
                    end if;

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

                if (add = '1' or ld = '1') then
                    OPC <= "0000";
                elsif (sub = '1') then
                    OPC <= "0001";
                elsif (andf = '1') then
                    OPC <= "0010";
                elsif (orf = '1') then
                    OPC <= "0011";
                elsif (xorf = '1') then
                    OPC <= "0100";
                end if;

                -- 00 for R-Type, 01 for J-Type, 10 for I-Type
                if (RType = '1') then
                    PCsel <= "00"; -- PC + 1
                elsif (JType = '1') then
                    PCsel <= "01"; -- pc + 1 + imm
                elsif (IType = '1') then
                    PCsel <= "00"; -- pc + 1
                    next_state <= Memory;
                end if;
                next_state <= WriteBack;

            when Memory =>
                    Cout <= '1';
                    Cin <= '0';
                    Ain <= '0';
                    RFin <= '0';
                    RFout <= '0';
                    IRin <= '0';
                    PCin <= '0';
                    Imm1_in <= '0';
                    Imm2_in <= '0';
                    Rfaddr <= "11";
                    OPC <= "0000";
                    PCsel <= "00"; -- PC + 1 
                if (ld='1') then -- LOAD instruction
                    Mem_wr <= '0';
                    Mem_out <= '0'; -- Mem read
                    Mem_in <= '0';
                    next_state <= WriteBack;
                elsif (st='1') then -- STORE instruction
                    Mem_wr <= '0';
                    Mem_out <= '0';
                    Mem_in <= '1';
                    next_state <= WriteBack;
                end if;

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
                -- sudo WB ()
                if (ld = '1') then
                    Mem_out <= '1';
                elsif (st = '1') then
                    Mem_wr <= '1';
                    Mem_out <= '0';
                    RFout <= '1';
                    RFin <= '0';
                end if;
                next_state <= Fetch;

            when others =>
                next_state <= Fetch;
        end case;
    end process;
end behavioral;

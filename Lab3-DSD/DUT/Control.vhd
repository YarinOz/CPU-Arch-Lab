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
        PCsel, Rfaddr: out std_logic_vector(1 downto 0)
        OPC: out std_logic_vector(3 downto 0)
    );
end ControlUnit;

architecture behavioral of ControlUnit is
    type state_type is (Fetch, Decode, Execute, Memory, WriteBack, Rexe1, Rexe2);
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
            PCin <= '1';
            Imm1_in <= '0';
            Imm2_in <= '0';
            PCsel <= "10";  -- zero initially
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
    RType := add or sub or andf or orf or xorf;
    JType := jmp or (jc and Cflag) or (jnc and not Cflag);
    IType := mov or ld or st or done;
    begin

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
                IRin <= '1';
                PCin <= '0'; 
                Imm1_in <= '0';
                Imm2_in <= '0';
                Rfaddr <= "11";
                OPC <= "0000";
                -- 00 for R-Type, 01 for J-Type, 10 for I-Type
                PCsel <= "00" when RType else  -- PC + 1
                          "01" when JType else -- pc + 1 + imm
                          "10" when IType;     -- 
                next_state <= Decode;

            when Decode =>
                PCin <= '0';
                IRin <= '0';
                next_state <= Execute when RType else
                              Memory when IType else
                              Fetch when done;
            when Execute =>
                -- RTYPE EXECUTION
                next_state <= Rexe1;
                when Rexe1 =>   -- first cycle
                    RFAaddr <= "00";
                    RFout <= '1';
                    Ain <= '1';
                    next_state <= Rexe2;
                
                when Rexe2 =>   -- second cycle
                    RFAaddr <= "01";
                    RFout <= '1';
                    Ain <= '0';
                    Cin <= '1';
                    OPC <= "0001" when add else
                           "0010" when sub else
                           "0011" when andf else
                           "0100" when orf else
                           "0101" when xorf;
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
                RFin <= '1';
                Cout <= '1';
                next_state <= Fetch;

            when others =>
                next_state <= Fetch;
        end case;
    end process;
end behavioral;

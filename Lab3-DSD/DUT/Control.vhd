library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ControlUnit is
    port(
        clk: in std_logic;
        reset: in std_logic;
        Status: in std_logic_vector(3 downto 0);
        -- Control signals for the datapath
        Mem_wr, Mem_out, Men_in, Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in : out std_logic;
        PCsel: out std_logic_vector(1 downto 0)
        OPC: out std_logic_vector(3 downto 0)
    );
end ControlUnit;

architecture behavioral of ControlUnit is
    type state_type is (Fetch, Decode, Execute, Memory, WriteBack);
    signal current_state, next_state: state_type;

begin

    OPC <= Status;

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= Fetch;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, Status)
    begin
        -- Default values for control signals
        Mem_wr <= '0';
        Mem_out <= '0';
        Men_in <= '0';
        Cout <= '0';
        Cin <= '0';
        Ain <= '0';
        RFin <= '0';
        RFout <= '0';
        IRin <= '0';
        PCin <= '0';
        Imm1_in <= '0';
        Imm2_in <= '0';
        PCsel <= "00";

        case current_state is
            when Fetch =>
                IRin <= '1';
                PCin <= '1';
                next_state <= Decode;

            when Decode =>
                case Status is
                    when "0000" => -- ADD instruction
                        next_state <= Execute;
                    when "0001" => -- SUB instruction
                        next_state <= Execute;
                    when "0010" => -- LOAD instruction
                        next_state <= Memory;
                    when "0011" => -- STORE instruction
                        next_state <= Memory;
                    when others =>
                        next_state <= Fetch;
                end case;

            when Execute =>
                case Status is
                    when "0000" => -- ADD instruction
                        Ain <= '1';
                        Cin <= '1';
                        Cout <= '1';
                        next_state <= WriteBack;
                    when "0001" => -- SUB instruction
                        Ain <= '1';
                        Cin <= '1';
                        Cout <= '1';
                        next_state <= WriteBack;
                    when others =>
                        next_state <= Fetch;
                end case;

            when Memory =>
                case Status is
                    when "0010" => -- LOAD instruction
                        Mem_out <= '1';
                        Men_in <= '1';
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
                next_state <= Fetch;

            when others =>
                next_state <= Fetch;
        end case;
    end process;
end behavioral;

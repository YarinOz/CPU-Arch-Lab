library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ControlUnit_tb is
end ControlUnit_tb;

architecture behavioral of ControlUnit_tb is
    -- Component declaration for the ControlUnit
    component ControlUnit is
        port(
            clk: in std_logic;
            rst: in std_logic;
            st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
            orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: in std_logic;
            -- Control signals for the datapath
            Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in : out std_logic;
            PCsel, Rfaddr: out std_logic_vector(1 downto 0);
            OPC: out std_logic_vector(3 downto 0);
            ena: in std_logic;
            done_FSM: out std_logic
        );
    end component;

    -- Test bench signals
    signal clk_tb, rst_tb, st_tb, ld_tb, mov_tb, done_tb, add_tb, sub_tb, jmp_tb, jc_tb, jnc_tb, andf_tb,
           orf_tb, xorf_tb, Cflag_tb, Zflag_tb, Nflag_tb, un1_tb, un2_tb, un3_tb, un4_tb, ena_tb: std_logic;
    signal Mem_wr_tb, Mem_out_tb, Mem_in_tb, Cout_tb, Cin_tb, Ain_tb, RFin_tb, RFout_tb, IRin_tb, PCin_tb, Imm1_in_tb, Imm2_in_tb: std_logic;
    signal PCsel_tb, Rfaddr_tb: std_logic_vector(1 downto 0);
    signal OPC_tb: std_logic_vector(3 downto 0);
    signal done_FSM_tb: std_logic;

    -- Clock generation
    constant clk_period: time := 10 ns;

begin

    -- Instantiate the ControlUnit
    uut: ControlUnit
        port map (
            clk => clk_tb,
            rst => rst_tb,
            st => st_tb,
            ld => ld_tb,
            mov => mov_tb,
            done => done_tb,
            add => add_tb,
            sub => sub_tb,
            jmp => jmp_tb,
            jc => jc_tb,
            jnc => jnc_tb,
            andf => andf_tb,
            orf => orf_tb,
            xorf => xorf_tb,
            Cflag => Cflag_tb,
            Zflag => Zflag_tb,
            Nflag => Nflag_tb,
            un1 => un1_tb,
            un2 => un2_tb,
            un3 => un3_tb,
            un4 => un4_tb,
            Mem_wr => Mem_wr_tb,
            Mem_out => Mem_out_tb,
            Mem_in => Mem_in_tb,
            Cout => Cout_tb,
            Cin => Cin_tb,
            Ain => Ain_tb,
            RFin => RFin_tb,
            RFout => RFout_tb,
            IRin => IRin_tb,
            PCin => PCin_tb,
            Imm1_in => Imm1_in_tb,
            Imm2_in => Imm2_in_tb,
            PCsel => PCsel_tb,
            Rfaddr => Rfaddr_tb,
            OPC => OPC_tb,
            ena => ena_tb,
            done_FSM => done_FSM_tb
        );

    -- Clock process
    clk_process : process
    begin
        clk_tb <= '1';
        wait for clk_period / 2;
        clk_tb <= '0';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        rst_tb <= '1';
        st_tb <= '0';
        ld_tb <= '0';
        mov_tb <= '0';
        done_tb <= '0';
        add_tb <= '0';
        sub_tb <= '0';
        jmp_tb <= '0';
        jc_tb <= '0';
        jnc_tb <= '0';
        andf_tb <= '0';
        orf_tb <= '0';
        xorf_tb <= '0';
        Cflag_tb <= '0';
        Zflag_tb <= '0';
        Nflag_tb <= '0';
        un1_tb <= '0';
        un2_tb <= '0';
        un3_tb <= '0';
        un4_tb <= '0';
        ena_tb <= '0';
        wait for 20 ns;

        -- Reset release
        rst_tb <= '0';
        ena_tb <= '1';
        wait for 20 ns;

        -- Test Case 1: MOV instruction
        mov_tb <= '1';
        wait for 30 ns;  -- MOV instruction takes 3 cycles
        mov_tb <= '0';
        wait for 20 ns;

        -- Test Case 2: ADD instruction
        add_tb <= '1';
        wait for 40 ns;  -- R-type instructions take 4 cycles
        add_tb <= '0';
        wait for 20 ns;

        -- Test Case 3: SUB instruction
        sub_tb <= '1';
        wait for 40 ns;  -- R-type instructions take 4 cycles
        sub_tb <= '0';
        wait for 20 ns;

        -- Test Case 4: JUMP instruction
        jmp_tb <= '1';
        wait for 20 ns;  -- J-type instructions take 2 cycles
        jmp_tb <= '0';
        wait for 20 ns;

        -- Test Case 5: JC instruction
        Cflag_tb <= '1';
        jc_tb <= '1';
        wait for 20 ns;  -- J-type instructions take 2 cycles
        jc_tb <= '0';
        Cflag_tb <= '0';
        wait for 20 ns;

        -- Test Case 6: JNC instruction
        jnc_tb <= '1';
        wait for 20 ns;  -- J-type instructions take 2 cycles
        jnc_tb <= '0';
        wait for 20 ns;

        -- Test Case 7: AND instruction
        andf_tb <= '1';
        wait for 40 ns;  -- R-type instructions take 4 cycles
        andf_tb <= '0';
        wait for 20 ns;

        -- Test Case 8: OR instruction
        orf_tb <= '1';
        wait for 40 ns;  -- R-type instructions take 4 cycles
        orf_tb <= '0';
        wait for 20 ns;

        -- Test Case 9: XOR instruction
        xorf_tb <= '1';
        wait for 40 ns;  -- R-type instructions take 4 cycles
        xorf_tb <= '0';
        wait for 20 ns;

        -- Test Case 10: LOAD instruction
        ld_tb <= '1';
        wait for 40 ns;  -- LD/ST instructions take 5 cycles
        ld_tb <= '0';
        wait for 20 ns;

        -- Test Case 11: STORE instruction
        st_tb <= '1';
        wait for 40 ns;  -- LD/ST instructions take 5 cycles
        st_tb <= '0';
        wait for 20 ns;

        -- Test Case 12: DONE instruction
        done_tb <= '1';
        wait for 20 ns;  -- DONE instruction takes 2 cycles
        done_tb <= '0';
        wait for 20 ns;

        -- Stop simulation
        wait;
    end process;

end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_CPU is
end tb_CPU;

architecture testbench of tb_CPU is
    -- Constants
    constant Dwidth: integer := 32;
    constant Awidth: integer := 5;
    constant Regwidth: integer := 4;
    constant dept: integer := 64;

    -- Signals
    signal clk, rst, init: std_logic := '0';
    signal RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: std_logic := '0';
    signal ALUop: std_logic_vector(5 downto 0) := (others => '0');
    signal opcode, funct: std_logic_vector(5 downto 0);

    signal AddressBus: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal ControlBus: std_logic_vector(15 downto 0) := (others => '0');
    signal DataBus: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progMemEn: std_logic := '0';
    signal progDataIn: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progWriteAddr: std_logic_vector(Awidth-1 downto 0) := (others => '0');
    signal dataMemEn: std_logic := '0';
    signal dataDataIn: std_logic_vector(Dwidth-1 downto 0);
    signal dataWriteAddr: std_logic_vector(Awidth-1 downto 0);

    -- Clock period
    constant clk_period: time := 10 ns;

begin
    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- CPU instantiation
    UUT: entity work.CPU
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            Regwidth => Regwidth,
            dept => dept
        )
        port map (
            clk => clk,
            rst => rst,
            init => init,
            AddressBus => AddressBus,
            ControlBus => ControlBus,
            DataBus => DataBus,
            progMemEn => progMemEn,
            progDataIn => progDataIn,
            progWriteAddr => progWriteAddr,
            dataMemEn => dataMemEn,
            dataDataIn => dataDataIn,
            dataWriteAddr => dataWriteAddr
        );

    -- Test process
    test_process: process
    begin
        -- Memory initialization
        init <= '1';
        -- Reset the system
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        
        -- Initialize data memory with some data
        dataWriteAddr <= b"00000";           -- Address 0
        dataDataIn <= x"00000002";           -- Data to be written
        dataMemEn <= '1';                        -- Enable initialization
        wait for clk_period;
        dataMemEn <= '0';                        -- Disable initialization

        dataWriteAddr <= b"00001";           -- Address 1
        dataDataIn <= x"00000005";           -- Another data
        dataMemEn <= '1';                        -- Enable initialization
        wait for clk_period;
        dataMemEn <= '0';                        -- Disable initialization

        -- Initialize program memory with some instructions
        progWriteAddr <= b"00000";           -- Address 0
        progDataIn <= x"8C040001";           -- lw $r4, 1($r0)
        progMemEn <= '1';
        wait for clk_period;
        progMemEn <= '0';

        progWriteAddr <= b"00001";           -- Address 1
        progDataIn <= x"20850007";           -- addi $r5, $r4, 7
        progMemEn <= '1';
        wait for clk_period;
        progMemEn <= '0';

        progWriteAddr <= b"00010";           -- Address 1
        progDataIn <= x"AC050002";           -- sw $r5, 3($r0)
        progMemEn <= '1';
        wait for clk_period;
        progMemEn <= '0';

        init <= '0';

        -- Wait for a few clock cycles to let the CPU run the program
        wait for 100 * clk_period;

        -- Finish simulation
        wait;
    end process;

end testbench;

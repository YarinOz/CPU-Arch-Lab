library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_Datapath is
end tb_Datapath;

architecture testbench of tb_Datapath is
    -- Constants
    constant Dwidth: integer := 32;
    constant Awidth: integer := 5;  -- Adjusted according to your Datapath
    constant Regwidth: integer := 4;
    constant dept: integer := 64;

    -- Signals
    signal clk, rst: std_logic := '0';
    signal RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: std_logic := '0';
    signal ALUop: std_logic_vector(5 downto 0) := (others => '0');
    signal opcode, funct: std_logic_vector(5 downto 0);
    signal progMemEn: std_logic := '0';
    signal progDataIn: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progWriteAddr: std_logic_vector(Awidth-1 downto 0) := (others => '0');

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

    -- DUT instantiation
    UUT: entity work.Datapath
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            Regwidth => Regwidth,
            dept => dept
        )
        port map (
            clk => clk,
            rst => rst,
            RegDst => RegDst,
            MemRead => MemRead,
            MemtoReg => MemtoReg,
            MemWrite => MemWrite,
            RegWrite => RegWrite,
            Branch => Branch,
            jump => jump,
            ALUsrc => ALUsrc,
            ALUop => ALUop,
            opcode => opcode,
            funct => funct,
            progMemEn => progMemEn,
            progDataIn => progDataIn,
            progWriteAddr => progWriteAddr
        );

    -- Test process
    test_process: process
    begin
        -- Reset the system
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- Initialize program memory with some instructions
        progWriteAddr <= b"00000";           -- Address 0
        progDataIn <= x"12345678";       -- Instruction or data
        progMemEn <= '1';
        wait for clk_period;
        progMemEn <= '0';

        progWriteAddr <= b"00100";           -- Address 4
        progDataIn <= x"9ABCDEF0";       -- Another instruction or data
        progMemEn <= '1';
        wait for clk_period;
        progMemEn <= '0';

        -- Add additional memory initialization as needed...

        -- Apply test vectors
        -- Set control signals for a specific test case
        RegDst <= '0';
        MemRead <= '0';
        MemtoReg <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Branch <= '0';
        jump <= '0';
        ALUsrc <= '0';
        ALUop <= b"000000"; -- Example ALU operation code

        -- Wait for a few clock cycles
        wait for 10 * clk_period;

        -- Add more test cases to verify different functionalities...

        -- Finish simulation
        wait;
    end process;

end testbench;

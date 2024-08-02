library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_CPU is
    constant dataMemResult:      string(1 to 82) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/DTCMcontent.txt";
    constant dataMemLocation:    string(1 to 79) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/DTCMinit.txt";
    constant progMemLocation:    string(1 to 79) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/ITCMinit.txt";
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
    signal dataDataOut: std_logic_vector(Dwidth-1 downto 0);

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
            dataWriteAddr => dataWriteAddr,
            dataDataOut => dataDataOut
        );

    -- Test process
    test_process: process
    -- File variables for reading instructions and data
    file instruction_file : text open read_mode is progMemLocation;
    file data_file : text open read_mode is dataMemLocation;
    variable instruction_line : line;
    variable data_line : line;
    variable addr : integer:= 0;
    variable data_value : std_logic_vector(Dwidth-1 downto 0);
    variable instruction_value : std_logic_vector(Dwidth-1 downto 0);
    begin
        -- Memory initialization
        init <= '1';
        -- Reset the system
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        
        -- Read and initialize data memory from file
        while not endfile(data_file) loop
            readline(data_file, data_line);
            hread(data_line, data_value); -- Read hex value
            dataWriteAddr <= conv_std_logic_vector(addr, Awidth);
            dataDataIn <= data_value;
            dataMemEn <= '1';
            wait for clk_period;
            dataMemEn <= '0';
            addr := addr + 1;
        end loop;

        -- Read and initialize program memory from file
        addr := 0;
        while not endfile(instruction_file) loop
            readline(instruction_file, instruction_line);
            hread(instruction_line, instruction_value); -- Read hex value
            progWriteAddr <= conv_std_logic_vector(addr, Awidth);
            progDataIn <= instruction_value;
            progMemEn <= '1';
            wait for clk_period;
            progMemEn <= '0';
            addr := addr + 1;
        end loop;
        init <= '0';

        wait;
    end process;


end testbench;

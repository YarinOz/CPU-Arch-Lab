library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.ALL;
use work.aux_package.ALL;

entity CPU_tb is
end CPU_tb;

architecture behav of CPU_tb is
    -- Constants for the testbench
    constant Dwidth : integer := 32;
    constant Awidth : integer := 5;
    constant dataFile:      string(1 to 82) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/DTCMcontent.txt";
    constant dataFileInit:  string(1 to 79) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/DTCMinit.txt";
    constant progFile:      string(1 to 79) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/ITCMinit.txt";
    
    -- Signals to connect to the CPU
    signal clk, rst, init : std_logic := '0';
    signal AddressBus : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal ControlBus : std_logic_vector(15 downto 0) := (others => '0');
    signal DataBus : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progMemEn, dataMemEn : std_logic := '0';
    signal progDataIn : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progWriteAddr : std_logic_vector(Awidth-1 downto 0) := (others => '0');
    signal dataDataIn : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal dataWriteAddr : std_logic_vector(Awidth-1 downto 0) := (others => '0');
    signal dataDataOut : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    
    -- Signals for checking results
    signal done_FSM : std_logic := '0';
begin
    -- Instantiate the CPU
    UUT: entity work.CPU
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth
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

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Reset generation
    reset_process : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    -- Data memory initialization
    LoadDataMem: process
        file inDmemfile : text open read_mode is dataFileInit;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0);
        variable good: boolean;
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0);
    begin
        TempAddresses := (others => '0');
        while not endfile(inDmemfile) loop
            readline(inDmemfile, L);
            hread(L, linetomem, good);
            next when not good;
            dataMemEn <= '1';
            dataWriteAddr <= TempAddresses;
            dataDataIn <= linetomem;
            wait until rising_edge(clk);
            TempAddresses := TempAddresses + 1;
        end loop;
        dataMemEn <= '0';
        file_close(inDmemfile);
        wait;
    end process;

    -- Program memory initialization
    LoadProgramMem: process
        file inPmemfile : text open read_mode is progFile;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0);
        variable good: boolean;
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0);
    begin
        TempAddresses := (others => '0');
        while not endfile(inPmemfile) loop
            readline(inPmemfile, L);
            hread(L, linetomem, good);
            next when not good;
            progMemEn <= '1';
            progWriteAddr <= TempAddresses;
            progDataIn <= linetomem;
            wait until rising_edge(clk);
            TempAddresses := TempAddresses + 1;
        end loop;
        progMemEn <= '0';
        file_close(inPmemfile);
        wait;
    end process;

    -- Set init to '0' to start the simulation
    init <= '0';

    -- Check results and write to file
    WriteToDataMem: process
        file outDmemfile : text open write_mode is dataFile;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0);
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0);
        variable counter: integer;
    begin
        wait until done_FSM = '1';
        TempAddresses := (others => '0');
        counter := 1;
        while counter < 3 loop -- Adjust based on the number of lines you need
            dataWriteAddr <= TempAddresses;
            wait until rising_edge(clk);
            wait until rising_edge(clk); -- Ensure data is stable
            linetomem := dataDataOut;
            hwrite(L, linetomem);
            writeline(outDmemfile, L);
            TempAddresses := TempAddresses + 1;
            counter := counter + 1;
        end loop;
        file_close(outDmemfile);
        wait;
    end process;

    -- Set done_FSM to '1' after some simulation time or based on conditions
    done_fsm_process : process
    begin
        wait for 500 ns; -- Adjust time as needed
        done_FSM <= '1';
        wait;
    end process;

end behav;

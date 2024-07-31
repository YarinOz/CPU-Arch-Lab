library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_tb is
end CPU_tb;

architecture Behavioral of CPU_tb is
    -- Constants for configuration
    constant Dwidth : integer := 32;
    constant Awidth : integer := 6;  -- Adjusted to match memory depth
    constant progMemDepth : integer := 64;  -- Depth of instruction memory
    constant dataMemDepth : integer := 64;  -- Depth of data memory

    -- Signals
    signal clk, rst, ena : std_logic;
    signal AddressBus : std_logic_vector(Dwidth-1 downto 0);
    signal ControlBus : std_logic_vector(15 downto 0);
    signal DataBus : std_logic_vector(Dwidth-1 downto 0);

    -- Program Memory signals
    signal progMemAddr : std_logic_vector(Awidth-1 downto 0);
    signal progMemData : std_logic_vector(Dwidth-1 downto 0);

    -- Data Memory signals
    signal dataMemAddr : std_logic_vector(Awidth-1 downto 0);
    signal dataMemDataIn : std_logic_vector(Dwidth-1 downto 0);
    signal dataMemDataOut : std_logic_vector(Dwidth-1 downto 0);
    signal dataMemEn : std_logic;

    -- Instantiate the CPU
    uut: entity work.CPU
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            Regwidth => 4,  -- Assuming this is a 4-bit register width
            dept => dataMemDepth
        )
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            AddressBus => AddressBus,
            ControlBus => ControlBus,
            DataBus => DataBus,
            -- Program Memory signals
            progMemEn => progMemEn,
            progDataIn => progMemData,
            progWriteAddr => progMemAddr,
            -- Data Memory signals
            dataMemEn => dataMemEn,
            dataDataIn => dataMemDataIn,
            dataWriteAddr => dataMemAddr,
            dataReadAddr => dataMemAddr,
            dataDataOut => dataMemDataOut
        );

    -- Instantiate Program Memory
    progMem: entity work.ProgMem
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            dept => progMemDepth
        )
        port map (
            RmemAddr => AddressBus,
            RmemData => progMemData
        );

    -- Instantiate Data Memory
    dataMem: entity work.dataMem
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            dept => dataMemDepth
        )
        port map (
            clk => clk,
            memEn => dataMemEn,
            WmemData => dataMemDataIn,
            WmemAddr => dataMemAddr,
            RmemData => dataMemDataOut
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
    rst_process : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initialize signals
        ena <= '0';
        progMemAddr <= (others => '0');
        progMemData <= (others => '0');
        dataMemAddr <= (others => '0');
        dataMemDataIn <= (others => '0');
        dataMemEn <= '0';

        -- Load program memory with instructions
        progMemAddr <= "000000";  -- Address 0
        progMemData <= x"00000001";  -- Example instruction (e.g., ADD)
        wait for 20 ns;

        progMemAddr <= "000001";  -- Address 1
        progMemData <= x"00000002";  -- Example instruction (e.g., SUB)
        wait for 20 ns;

        -- Enable CPU and start execution
        ena <= '1';
        wait for 50 ns;

        -- Test data memory write
        dataMemEn <= '1';
        dataMemAddr <= "000000";
        dataMemDataIn <= x"0000000A";  -- Example data
        wait for 20 ns;

        dataMemAddr <= "000001";
        dataMemDataIn <= x"00000014";  -- Example data
        wait for 20 ns;
        dataMemEn <= '0';

        -- Add more tests as needed to verify CPU functionality

        -- End simulation
        wait;
    end process;
end Behavioral;

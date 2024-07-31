library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CPU_tb is
end CPU_tb;

architecture Behavioral of CPU_tb is
    -- Constants for configuration
    constant Dwidth : integer := 32;
    constant Awidth : integer := 32;
    constant memDepth : integer := 64;

    -- Signals for CPU
    signal clk, rst, ena : std_logic;
    signal AddressBus : std_logic_vector(Dwidth-1 downto 0);
    signal ControlBus : std_logic_vector(15 downto 0);
    signal DataBus : std_logic_vector(Dwidth-1 downto 0);

    -- Signals for memory
    signal progMemEn : std_logic;
    signal progDataIn : std_logic_vector(Dwidth-1 downto 0);
    signal progWriteAddr : std_logic_vector(Awidth-1 downto 0);
    signal dataMemEn : std_logic;
    signal dataDataIn : std_logic_vector(Dwidth-1 downto 0);
    signal dataWriteAddr, dataReadAddr : std_logic_vector(Awidth-1 downto 0);
    signal dataDataOut : std_logic_vector(Dwidth-1 downto 0);

    -- Instantiate the CPU
    uut: entity work.CPU
        generic map (
            Dwidth => Dwidth,
            Awidth => Awidth,
            Regwidth => 4,  -- Adjust as needed
            dept => memDepth
        )
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            AddressBus => AddressBus,
            ControlBus => ControlBus,
            DataBus => DataBus,
            progMemEn => progMemEn,
            progDataIn => progDataIn,
            progWriteAddr => progWriteAddr,
            dataMemEn => dataMemEn,
            dataDataIn => dataDataIn,
            dataWriteAddr => dataWriteAddr,
            dataReadAddr => dataReadAddr,
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
        progMemEn <= '0';
        dataMemEn <= '0';
        progDataIn <= (others => '0');
        progWriteAddr <= (others => '0');
        dataDataIn <= (others => '0');
        dataWriteAddr <= (others => '0');
        dataReadAddr <= (others => '0');
        
        -- Load program memory
        progMemEn <= '1';
        progWriteAddr <= "000000"; -- Start address
        progDataIn <= x"00000000"; -- Example instruction (NOP)
        wait for 20 ns;
        progWriteAddr <= "000001";
        progDataIn <= x"00000001"; -- Example instruction (some operation)
        wait for 20 ns;
        progMemEn <= '0';
        
        -- Enable CPU
        ena <= '1';
        wait for 50 ns;

        -- Test data memory write
        dataMemEn <= '1';
        dataWriteAddr <= "000000";
        dataDataIn <= x"0000000A"; -- Example data
        wait for 20 ns;
        dataWriteAddr <= "000001";
        dataDataIn <= x"00000014"; -- Example data
        wait for 20 ns;
        dataMemEn <= '0';

        -- Test CPU operations
        -- Here you would typically add test cases to verify the CPU functionality
        -- For example, you could check the contents of DataBus, AddressBus, and ControlBus
        -- after specific instructions are processed.

        -- End simulation
        wait;
    end process;
end Behavioral;

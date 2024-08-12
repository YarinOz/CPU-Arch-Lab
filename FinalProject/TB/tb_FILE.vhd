library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity CPU_tb is
end CPU_tb;

architecture sim of CPU_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;

    -- Signals for CPU
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal ena : std_logic := '0';
    signal AddressBus : std_logic_vector(31 downto 0) := (others => '0');
    signal ControlBus : std_logic_vector(15 downto 0) := (others => '0');
    signal DataBus : std_logic_vector(31 downto 0) := (others => '0');
    
begin
    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Testbench stimulus process
    stimulus : process
    begin
        -- Initialize signals
        rst <= '1';
        ena <= '0';
        wait for CLK_PERIOD * 2;
        
        rst <= '0';
        ena <= '1';
        
        -- Allow some time for reset to take effect
        wait for CLK_PERIOD * 10;
        
        -- Example test sequence (you may need to adjust timing and signals)
        -- No need to change AddressBus or DataBus as program memory is initialized from ITCM.hex
        wait for CLK_PERIOD * 10;

        -- Check outputs or observe simulation results
        -- You can add additional checks or log outputs if needed

        -- Finish simulation
        wait;
    end process;
    
    -- Instantiate the CPU
    uut : entity work.CPU
        generic map (
            Dwidth => 32,
            Awidth => 8,
            Regwidth => 8
        )
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            AddressBus => AddressBus,
            ControlBus => ControlBus,
            DataBus => DataBus
        );
end sim;

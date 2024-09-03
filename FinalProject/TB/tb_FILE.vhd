library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MCU_tb is
end MCU_tb;

architecture sim of MCU_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;

    -- Signals for MCU
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal ena : std_logic := '0';
    
    signal SW : std_logic_vector(8 downto 0);
    signal KEY0, KEY1, KEY2, KEY3 : std_logic;
    signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0);
    signal LEDs : std_logic_vector(9 downto 0);
    signal BTOUT : std_logic;

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
    
    -- Instantiate the MCU

    uut: entity work.MCU
        generic map(
            Dwidth => 32,
            Awidth => 12,
            Regwidth => 8,
            sim => true
        )
        port map(
            clk => clk,
            rst => rst,
            ena => ena,
            SW => "000001010",
            KEY0 => KEY0,
            KEY1 => KEY1,
            KEY2 => KEY2,
            KEY3 => KEY3,
            HEX0 => HEX0,
            HEX1 => HEX1,
            HEX2 => HEX2,
            HEX3 => HEX3,
            HEX4 => HEX4,
            HEX5 => HEX5,
            LEDs => LEDs,
            BTOUT => BTOUT
        );

end sim;

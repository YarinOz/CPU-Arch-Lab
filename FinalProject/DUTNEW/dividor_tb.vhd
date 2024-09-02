library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.aux_package.all;

entity tb_dividerEnv is
-- Testbench does not have ports
end tb_dividerEnv;

architecture behavior of tb_dividerEnv is

    -- Component declaration for the dividerEnv
    component dividerEnv
        port (
            rst, en, clk : in std_logic;
            MemWrite, MemRead : in std_logic;
            addressbus : in std_logic_vector(11 downto 0);
            databus : inout std_logic_vector(31 downto 0);
            set_divifg : out std_logic
        );
    end component;

    -- Signals to connect to the dividerEnv
    signal rst, en, clk : std_logic := '0';
    signal MemWrite, MemRead : std_logic := '0';
    signal addressbus : std_logic_vector(11 downto 0) := (others => '0');
    signal databus : std_logic_vector(31 downto 0) := (others => '0');
    signal set_divifg : std_logic;

begin

    -- Instantiate the dividerEnv
    uut: dividerEnv
        port map (
            rst => rst,
            en => en,
            clk => clk,
            MemWrite => MemWrite,
            MemRead => MemRead,
            addressbus => addressbus,
            databus => databus,
            set_divifg => set_divifg
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Apply reset
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        
        -- Enable and write to the divisor address
        en <= '1';
        MemWrite <= '1';
        MemRead <= '0';
        addressbus <= x"830";
        databus <= x"00000010"; -- Example divisor value
        wait for 20 ns;
        
        -- Write to the dividend address
        addressbus <= x"82C";
        databus <= x"00000064"; -- Example dividend value
        wait for 20 ns;
        
        -- Set MemWrite to '0' and MemRead to '1' for read operations
        -- MemWrite <= '0';
        -- MemRead <= '1';
        
        -- -- Perform read operations or further writes
        -- addressbus <= x"830"; -- Reading divisor
        -- wait for 20 ns;

        -- Check if `set_divifg` is asserted after 32 clock cycles
        wait for 400 ns; -- Wait for the entire division operation (32 clocks * 10 ns)

        -- Check if `set_divifg` is asserted
        if set_divifg = '1' then
            report "Divider operation completed successfully" severity note;
        else
            report "Divider operation did not complete" severity error;
        end if;
        
        -- End simulation
        wait;
    end process;

end behavior;

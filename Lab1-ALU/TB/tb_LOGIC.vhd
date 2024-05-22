LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;

ENTITY tb_LOGIC IS
END tb_LOGIC;

ARCHITECTURE behavior OF tb_LOGIC IS

    -- Inputs
    signal x : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal y : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal mode : std_logic_vector(2 DOWNTO 0) := (others => '0');

    -- Outputs
    signal s : std_logic_vector(7 DOWNTO 0);

    -- Clock period definitions (if needed for more complex synchronous designs)
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: LOGIC PORT MAP (
          x => x,
          y => y,
          mode => mode,
          s => s
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- Test case 1: NOT y
        x <= "00000000";
        y <= "11110000";
        mode <= "000";
        wait for 20 ns;
        assert(s = "00001111")
            report "Test case 1 failed" severity error;

        -- Test case 2: OR
        x <= "00001111";
        y <= "11110000";
        mode <= "001";
        wait for 20 ns;
        assert(s = "11111111")
            report "Test case 2 failed" severity error;

        -- Test case 3: AND
        x <= "00001111";
        y <= "11110000";
        mode <= "010";
        wait for 20 ns;
        assert(s = "00000000")
            report "Test case 3 failed" severity error;

        -- Test case 4: XOR
        x <= "00001111";
        y <= "11111000";
        mode <= "011";
        wait for 20 ns;
        assert(s = "11110111")
            report "Test case 4 failed" severity error;

        -- Test case 5: NOR
        x <= "00001111";
        y <= "11111000";
        mode <= "100";
        wait for 20 ns;
        assert(s = "00000000")
            report "Test case 5 failed" severity error;

        -- Test case 6: NAND
        x <= "00001111";
        y <= "11111000";
        mode <= "101";
        wait for 20 ns;
        assert(s = "11110111")
            report "Test case 6 failed" severity error;

        -- Test case 7: XNOR
        x <= "00001111";
        y <= "11111000";
        mode <= "111";
        wait for 20 ns;
        assert(s = "00001000")
            report "Test case 7 failed" severity error;

        -- Test case 8: undefined (zero)
        x <= "00001111";
        y <= "11110000";
        mode <= "110";
        wait for 20 ns;
        assert(s = "00000000")
            report "Test case 8 failed" severity error;

        wait;
    end process;

END behavior;


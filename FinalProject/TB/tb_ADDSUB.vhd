LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;

ENTITY tb_AdderSub IS
END tb_AdderSub;

ARCHITECTURE behavior OF tb_AdderSub IS

    -- Inputs
    signal x : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal y : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal sub_c : std_logic := '0';

    -- Outputs
    signal s : std_logic_vector(7 DOWNTO 0);
    signal cout : std_logic;

    -- Clock period definitions (if needed for more complex synchronous designs)
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: AdderSub PORT MAP (
          x => x,
          y => y,
          sub_c => sub_c,
          s => s,
          cout => cout
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- Test case 1: Addition  
        x <= "00000001";  -- 1
        y <= "00000010";  -- 2
        sub_c <= '0';     -- Addition
        wait for 20 ns;
        assert(s = "00000011" and cout = '0')
            report "Test case 1 failed" severity error;

	    -- Test case 2: Addition carry out
        x <= "11111111";  -- 255
        y <= "00000010";  -- 2
        sub_c <= '0';     -- Addition
        wait for 20 ns;
        assert(s = "00000001" and cout = '1')
            report "Test case 2 failed" severity error;

        -- Test case 3: Subtraction 
        x <= "00000111";  -- 7
        y <= "00000010";  -- 2
        sub_c <= '1';     -- Subtraction
        wait for 20 ns;
        assert(s = "11111011" and cout = '0')
            report "Test case 3 failed" severity error;

        -- Test case 4: Negative
        x <= "00100111";  -- 39
        y <= "00000000";  -- 0
        sub_c <= '1';     -- negative
        wait for 20 ns;
        assert(s = "11011001" and cout = '0')
            report "Test case 4 failed" severity error;
        
        -- End simulation
        wait;
    end process;

END;

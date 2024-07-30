LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;

ENTITY tb_Shifter IS
END tb_Shifter;

ARCHITECTURE behavior OF tb_Shifter IS
    
    -- Inputs
    signal x : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal y : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal dir : std_logic_vector(2 DOWNTO 0) := (others => '0');

    -- Outputs
    signal cout : std_logic;
    signal res : std_logic_vector(7 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Shifter
    PORT MAP (
        x => x,
        y => y,
        dir => dir,
        cout => cout,
        res => res
    );

    -- Stimulus process
    stim_proc: process
    begin

        -- Test case 1: Left shift y by 1
        x <= "00000001";  -- Shift by 1
        y <= "00000001";  -- Binary value 1
        dir <= "000";       -- Left shift
        wait for 20 ns;
        assert(res = "00000010" and cout = '0')
            report "Test case 1 failed" severity error;

        -- Test case 2: Left shift y by 2
        x <= "00000010";  -- Shift by 2
        y <= "00000001";  -- Binary value 1
        dir <= "000";       -- Left shift
        wait for 20 ns;
        assert(res = "00000100" and cout = '0')
            report "Test case 2 failed" severity error;

        -- Test case 3: Left shift y by 1 with carry
        x <= "00000001";  -- Shift by 1
        y <= "10000000";  -- Binary value 128
        dir <= "000";       -- Left shift
        wait for 20 ns;
        assert(res = "00000000" and cout = '1')
        report "Test case 3 failed" severity error;

        -- Test case 4: Right shift y by 1
        x <= "00000001";  -- Shift by 1
        y <= "00000010";  -- Binary value 2
        dir <= "001";       -- Right shift
        wait for 20 ns;
        assert(res = "00000001" and cout = '0')
        report "Test case 4 failed" severity error;

        -- Test case 5: Right shift y by 3
        x <= "00000011";  -- Shift by 3
        y <= "10000000";  -- Binary value 128
        dir <= "001";       -- Right shift
        wait for 20 ns;
        assert(res = "00010000" and cout = '0')
        report "Test case 5 failed" severity error;
	
        -- Test case 6: Right shift y by 2 with carry
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= "001";       -- Right shift
        wait for 20 ns;
        assert(res = "00100000" and cout = '1')
        report "Test case 6 failed" severity error;

        -- Test case 7: Undefined shift
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= "101";       -- Right shift
        wait for 20 ns;
        assert(res = "00000000" and cout = '0')
        report "Test case 7 failed" severity error;

        -- Test case 8: Undefined shift
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= "010";       -- Right shift
        wait for 20 ns;
        assert(res = "00000000" and cout = '0')
        report "Test case 8 failed" severity error;

        -- Test case 9: Undefined shift
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= "011";       -- Right shift
        wait for 20 ns;
        assert(res = "00000000" and cout = '0')
        report "Test case 9 failed" severity error;

        -- Test case 10: Undefined shift
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= "111";       -- Right shift
        wait for 20 ns;
        assert(res = "00000000" and cout = '0')
        report "Test case 10 failed" severity error;

        -- End simulation
        wait;

    end process;

END behavior;


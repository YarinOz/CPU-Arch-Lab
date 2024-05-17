LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;

ENTITY tb_Shifter IS
END tb_Shifter;

ARCHITECTURE behavior OF tb_Shifter IS
    
    -- Inputs
    signal x : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal y : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal dir : std_logic := '0';

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
        -- Initialize Inputs
        x <= "00000000";
        y <= "00000000";
        dir <= '0'; -- Left shift
        wait for 20 ns;

        -- Test case 1: Left shift y by 1
        x <= "00000001";  -- Shift by 1
        y <= "00000001";  -- Binary value 1
        dir <= '0';       -- Left shift
        wait for 20 ns;

        -- Test case 2: Left shift y by 2
        x <= "00000010";  -- Shift by 2
        y <= "00000001";  -- Binary value 1
        dir <= '0';       -- Left shift
        wait for 20 ns;

        -- Test case 3: Left shift y by 1 with carry
        x <= "00000001";  -- Shift by 1
        y <= "10000000";  -- Binary value 128
        dir <= '0';       -- Left shift
        wait for 20 ns;

        -- Test case 4: Right shift y by 1
        x <= "00000001";  -- Shift by 1
        y <= "00000010";  -- Binary value 2
        dir <= '1';       -- Right shift
        wait for 20 ns;

        -- Test case 5: Right shift y by 3
        x <= "00000011";  -- Shift by 3
        y <= "10000000";  -- Binary value 128
        dir <= '1';       -- Right shift
        wait for 20 ns;
	
        -- Test case 6: Right shift y by 2 with carry
        x <= "00000010";  -- Shift by 2
        y <= "10000011";  -- Binary value 131
        dir <= '1';       -- Right shift
        wait for 20 ns;
	
        -- Add more test cases as needed

        -- End simulation
        wait;

    end process;

END behavior;


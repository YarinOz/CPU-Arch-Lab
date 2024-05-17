LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS

    -- Constants for the test bench
    constant n : integer := 8;
    constant k : integer := 3;   -- k=log2(n)
    constant m : integer := 4;   -- m=2^(k-1)
    
    -- Signals for connecting the UUT
    SIGNAL Y_i, X_i : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL ALUFN_i : std_logic_vector(4 DOWNTO 0);
    SIGNAL ALUout_o : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL Nflag_o : std_logic;
    SIGNAL Cflag_o : std_logic;
    SIGNAL Zflag_o : std_logic;
    SIGNAL OF_flag_o : std_logic;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: top
    GENERIC MAP (
        n => n,
        k => k,
        m => m
    )
    PORT MAP (
        Y_i => Y_i,
        X_i => X_i,
        ALUFN_i => ALUFN_i,
        ALUout_o => ALUout_o,
        Nflag_o => Nflag_o,
        Cflag_o => Cflag_o,
        Zflag_o => Zflag_o,
        OF_flag_o => OF_flag_o
    );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Initialize Inputs
        X_i <= (others => '0');
        Y_i <= (others => '0');
        ALUFN_i <= (others => '0');
        wait for 100 ns;
        
        -- Test addition
        X_i <= "00001010"; -- 10
        Y_i <= "00000101"; -- 5
        ALUFN_i <= "01000"; -- ALU function code for addition
        wait for 100 ns;

 	-- Test addition OF
        X_i <= "01111111"; -- 10
        Y_i <= "00000001"; -- 5
        ALUFN_i <= "01000"; -- ALU function code for addition
        wait for 100 ns;

        -- Test subtraction
        X_i <= "00001010"; -- 10
        Y_i <= "00000101"; -- 5
        ALUFN_i <= "01001"; -- ALU function code for subtraction
        wait for 100 ns;

	-- Test MINUS
        X_i <= "00001010"; -- 10
        Y_i <= "00000101"; -- 5
        ALUFN_i <= "01010"; -- ALU function code for subtraction
        wait for 100 ns;

        -- Test logical AND
        X_i <= "10101010"; -- 170
        Y_i <= "01010101"; -- 85
        ALUFN_i <= "11010"; -- ALU function code for AND
        wait for 100 ns;

        -- Test logical OR
        X_i <= "10101010"; -- 170
        Y_i <= "01010101"; -- 85
        ALUFN_i <= "11001"; -- ALU function code for OR
        wait for 100 ns;

        -- Test left shift
        X_i <= "00000010"; -- 2
        Y_i <= "00000001"; -- 1 (shift left by 1)
        ALUFN_i <= "10000"; -- ALU function code for shift left
        wait for 100 ns;

        -- Test right shift
        X_i <= "00000010"; -- 2
        Y_i <= "00000001"; -- 1 (shift right by 1)
        ALUFN_i <= "10001"; -- ALU function code for shift right
        wait for 100 ns;

        -- Test for zero flag
        X_i <= "00000000"; -- 0
        Y_i <= "00000000"; -- 0
        ALUFN_i <= "01000"; -- ALU function code for addition (0+0)
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

END behavior;


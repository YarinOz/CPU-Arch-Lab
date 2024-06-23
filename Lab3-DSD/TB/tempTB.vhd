LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;  -- For converting std_logic_vector to integer

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE tb_arch OF ALU_tb IS
    -- Constants
    CONSTANT Dwidth : INTEGER := 16;

    -- Signals for test bench
    SIGNAL Y_i, X_i : std_logic_vector(Dwidth-1 DOWNTO 0) := (others => '0');
    SIGNAL ALUFN_i : std_logic_vector(3 DOWNTO 0) := "0000";  -- Initialize ALUFN_i for addition
    SIGNAL ALUout_o : std_logic_vector(Dwidth-1 DOWNTO 0);
    SIGNAL Nflag_o, Cflag_o, Zflag_o: std_logic;

BEGIN
    -- Component instantiation
    UUT : entity work.ALU
    GENERIC MAP (
        Dwidth => Dwidth
    )
    PORT MAP (
        Y_i => Y_i,
        X_i => X_i,
        ALUFN_i => ALUFN_i,
        ALUout_o => ALUout_o,
        Nflag_o => Nflag_o,
        Cflag_o => Cflag_o,
        Zflag_o => Zflag_o
    );

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Test 1: Addition operation
        X_i <= "0000000000000101";  -- 5
        Y_i <= "0000000000000011";  -- 3
        ALUFN_i <= "0000";  -- Addition
        WAIT FOR 10 ns;

        -- Test 2: Subtraction operation
        X_i <= "0000000000000101";  -- 5
        Y_i <= "0000000000000011";  -- 3
        ALUFN_i <= "0001";  -- Subtraction
        WAIT FOR 10 ns;

        -- Test 2: OF operation
        X_i <= "1111111111111111";  -- 5
        Y_i <= "0000000000000011";  -- 3
        ALUFN_i <= "0000";  -- Addition
        WAIT FOR 10 ns;

        -- Test 3: Logic AND operation
        X_i <= "0000000000001100";  -- 12
        Y_i <= "0000000000001010";  -- 10
        ALUFN_i <= "0010";  -- AND
        WAIT FOR 10 ns;
        -- Test 2: Subtraction operation
        X_i <= "0000000000000110";  -- 0x06
        Y_i <= "0000000000010111";  -- 0x17
        ALUFN_i <= "0001";  -- Subtraction
        WAIT FOR 10 ns;

        -- Test 4: Logic OR operation
        X_i <= "0000000000001100";  -- 12
        Y_i <= "0000000000001010";  -- 10
        ALUFN_i <= "0011";  -- OR
        WAIT FOR 10 ns;

        -- Test 5: Logic XOR operation
        X_i <= "0000000000001100";  -- 12
        Y_i <= "0000000000001010";  -- 10
        ALUFN_i <= "0100";  -- XOR
        WAIT FOR 10 ns;

        -- Test 6: Check flags for all zeros
        X_i <= "0000000000000000";  -- 0
        Y_i <= "0000000000000000";  -- 0
        ALUFN_i <= "0000";  -- Addition
        WAIT FOR 10 ns;

        -- End of simulation
        WAIT;
    END PROCESS;

    -- Check Cflag, Nflag, Zflag outputs
    check_flags: PROCESS
    BEGIN
        WAIT FOR 1 ns;  -- Wait for signals to settle

        -- Display results for each test
        REPORT "-----------------------------" & LF;
        REPORT "Test 1 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT FOR 10 ns;  -- Wait before checking next test

        REPORT "-----------------------------" & LF;
        REPORT "Test 2 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT FOR 10 ns;  -- Wait before checking next test

        REPORT "-----------------------------" & LF;
        REPORT "Test 3 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT FOR 10 ns;  -- Wait before checking next test

        REPORT "-----------------------------" & LF;
        REPORT "Test 4 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT FOR 10 ns;  -- Wait before checking next test

        REPORT "-----------------------------" & LF;
        REPORT "Test 5 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT FOR 10 ns;  -- Wait before checking next test

        REPORT "-----------------------------" & LF;
        REPORT "Test 6 Results:" & LF;
        REPORT "Cflag = " & std_logic'image(Cflag_o) & LF;
        REPORT "Nflag = " & std_logic'image(Nflag_o) & LF;
        REPORT "Zflag = " & std_logic'image(Zflag_o) & LF;

        WAIT;  -- End simulation
    END PROCESS;

END tb_arch;

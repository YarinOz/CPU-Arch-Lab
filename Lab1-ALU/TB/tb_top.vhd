LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.aux_package.all;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS 

  -- Signals for connecting to UUT
  SIGNAL Y_i : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL X_i : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ALUFN_i : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ALUout_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL Nflag_o, Cflag_o, Zflag_o, OF_flag_o : STD_LOGIC;
  
  -- Clock period definitions
  CONSTANT clk_period : time := 10 ns;

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: top PORT MAP (
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
    -- Test Case 1: Simple Addition
    X_i <= "00000011"; -- 3
    Y_i <= "00000001"; -- 1
    ALUFN_i <= "01000"; -- ALUFN_i(4 downto 3) = "01" for addition
    wait for clk_period;
    assert (ALUout_o = "00000100") report "Test Case 1 failed" severity error;
    
    -- Test Case 2: Simple Subtraction
    X_i <= "00000011"; -- 3
    Y_i <= "00000001"; -- 1
    ALUFN_i <= "01001"; -- ALUFN_i(4 downto 3) = "01" and ALUFN_i(0) = 1 for subtraction
    wait for clk_period;
    assert (ALUout_o = "00000010") report "Test Case 2 failed" severity error;
    
    -- Test Case 3: Overflow Detection
    X_i <= "01111111"; -- 127
    Y_i <= "00000001"; -- 1
    ALUFN_i <= "01000"; -- ALUFN_i(4 downto 3) = "01" for addition
    wait for clk_period;
    assert (OF_flag_o = '1') report "Test Case 3 failed" severity error;

    -- Test Case 4: AND Operation
    X_i <= "00001111"; 
    Y_i <= "11110000"; 
    ALUFN_i <= "11000"; -- ALUFN_i(4 downto 3) = "11" for logic operations, mode = "000" for AND
    wait for clk_period;
    assert (ALUout_o = "00000000") report "Test Case 4 failed" severity error;

    -- Test Case 5: OR Operation
    X_i <= "00001111"; 
    Y_i <= "11110000"; 
    ALUFN_i <= "11001"; -- ALUFN_i(4 downto 3) = "11" for logic operations, mode = "001" for OR
    wait for clk_period;
    assert (ALUout_o = "11111111") report "Test Case 5 failed" severity error;

    -- Test Case 6: Zero Flag
    X_i <= "00001111"; 
    Y_i <= "11110000"; 
    ALUFN_i <= "11000"; -- ALUFN_i(4 downto 3) = "11" for logic operations, mode = "000" for AND
    wait for clk_period;
    assert (Zflag_o = '1') report "Test Case 6 failed" severity error;

    -- Test Case 7: Shifting Left
    X_i <= "00000001";
    Y_i <= "00000010";
    ALUFN_i <= "10000"; -- ALUFN_i(4 downto 3) = "10" for shift operations, mode = "000" for left shift
    wait for clk_period;
    assert (ALUout_o = "00000100") report "Test Case 7 failed" severity error;

    -- Test Case 8: Shifting Right
    X_i <= "00000100";
    Y_i <= "00000010";
    ALUFN_i <= "10001"; -- ALUFN_i(4 downto 3) = "10" for shift operations, mode = "001" for right shift
    wait for clk_period;
    assert (ALUout_o = "00000001") report "Test Case 8 failed" severity error;

    -- Test Case 9: Carry Flag Detection
    X_i <= "11111111"; 
    Y_i <= "00000001"; 
    ALUFN_i <= "01000"; -- ALUFN_i(4 downto 3) = "01" for addition
    wait for clk_period;
    assert (Cflag_o = '1') report "Test Case 9 failed" severity error;

    wait;
  end process;

END behavior;

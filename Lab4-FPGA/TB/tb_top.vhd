LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.aux_package.all;

ENTITY tb_TopEntity IS
END tb_TopEntity;

ARCHITECTURE behavior OF tb_TopEntity IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT TopEntity
        GENERIC (
            n : INTEGER := 8;
            k : integer := 3;
            m : integer := 4
        );
        PORT (
            ENA, RST, CLK : IN STD_LOGIC;
            Y_i, X_i : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            ALUout_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            Nflag_o, Cflag_o, Zflag_o, OF_flag_o, PWMout : OUT STD_LOGIC 
        );
    END COMPONENT;

    -- Signals for UUT
    SIGNAL ENA, RST, CLK : STD_LOGIC := '0';
    SIGNAL Y_i, X_i : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALUFN_i : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALUout_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Nflag_o, Cflag_o, Zflag_o, OF_flag_o, PWMout_o : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: TopEntity PORT MAP (
        ENA => ENA,
        RST => RST,
        CLK => CLK,
        Y_i => Y_i,
        X_i => X_i,
        ALUFN_i => ALUFN_i,
        ALUout_o => ALUout_o,
        Nflag_o => Nflag_o,
        Cflag_o => Cflag_o,
        Zflag_o => Zflag_o,
        OF_flag_o => OF_flag_o,
        PWMout => PWMout_o
    );

    -- Clock process definitions
    clk_process :process
    BEGIN
        CLK <= '0';
        WAIT FOR clk_period/2;
        CLK <= '1';
        WAIT FOR clk_period/2;
    END PROCESS clk_process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        RST <= '1';
        WAIT FOR clk_period;
        RST <= '0';
        
        -- Enable the system
        ENA <= '1';

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
        ALUFN_i <= "11010"; -- ALUFN_i(4 downto 3) = "11" for logic operations, mode = "000" for AND
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

        -- PWM Test Case
        -- Test Case 10: PWM Signal Generation with mode 0
        Y_i <= "11111110"; -- Y_i set for PWM threshold
        X_i <= "01111111"; -- X_i set for PWM threshold
        ALUFN_i <= "00000"; -- Mode for PWM operation
        ENA <= '1';
        wait for 100 * clk_period;
        assert (PWMout_o = '1') report "Test Case 10 failed" severity error;

        -- Test Case 11: PWM Signal Generation with mode 1
        Y_i <= "11111110"; -- Y_i set for PWM threshold
        X_i <= "00111111"; -- X_i set for PWM threshold
        ALUFN_i <= "00001"; -- Mode for PWM operation
        ENA <= '1';
        wait for 100 * clk_period;
        assert (PWMout_o = '1') report "Test Case 11 failed" severity error;

        wait;
    end process;

END behavior;

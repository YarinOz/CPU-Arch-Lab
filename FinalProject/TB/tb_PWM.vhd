LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PWM_tb IS
END PWM_tb;

ARCHITECTURE behavior OF PWM_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT PWM
    GENERIC (
        n : INTEGER := 8
    );
    PORT (
        Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        CLK, ENA, RST : IN STD_LOGIC;
        PWMout : OUT STD_LOGIC
    );
    END COMPONENT;
   
    --Inputs
    signal Y_i, X_i : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ALUFN_i : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal CLK, ENA, RST : STD_LOGIC := '0';

    --Outputs
    signal PWMout : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 1 ns;
 
BEGIN 
    -- Instantiate the Unit Under Test (UUT)
    uut: PWM PORT MAP (
          Y_i => Y_i,
          X_i => X_i,
          ALUFN_i => ALUFN_i,
          CLK => CLK,
          ENA => ENA,
          RST => RST,
          PWMout => PWMout
        );

    -- Clock process definitions
    CLK_process :process
    begin
        CLK <= '0';
        wait for clk_period/2;
        CLK <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin       
        -- Initialize Inputs
        RST <= '1'; wait for 2 ns;
        RST <= '0'; wait for 1 ns;
        ENA <= '1';
        Y_i <= "11111110";
        X_i <= "01111111";
        ALUFN_i <= "00000"; -- Example mode
        wait for 10 ns;
        
        -- Add more stimulus here

        wait;
    end process;

END behavior;
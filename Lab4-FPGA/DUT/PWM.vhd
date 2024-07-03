LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY PWM IS
  GENERIC (
    n : INTEGER := 8
  );
  PORT (
    Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
    CLK,ENA,RST : IN STD_LOGIC;
    PWMout : OUT STD_LOGIC
  ); -- Zflag, Cflag, Nflag, Vflag
END PWM;

ARCHITECTURE struct OF PWM IS
  -- signal declaration
  SIGNAL CounterValue : std_logic_vector (7 DOWNTO 0):=x"00";
  SIGNAL PWMmode, PWMsignal : std_logic;
BEGIN
    -- component declaration
    count : counter
    PORT MAP (
        clk => CLK,
        enable => ENA,
        q => CounterValue
    );
    -- set/rest or reset/set mode
    PWMmode <= ALUFN_i(0);

    -- compare the counter value with the input value
    process (CLK, RST, ENA)
    begin
        -- asynchronous reset
        if (RST = '1') then
            PWMsignal <= '0';
        elsif (rising_edge(CLK) and ENA = '1') then
            if (CounterValue = X_i) then
                PWMsignal <= '1';
            elsif (CounterValue = Y_i) then
                PWMsignal <= '0';
            end if;
        end if;
    end process;

    -- output assignment
    PWMout <=  PWMsignal WHEN PWMmode='0' ELSE
               (NOT PWMsignal) WHEN PWMmode='1' ELSE
               '0';
             
END struct;

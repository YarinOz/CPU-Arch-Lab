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
  SIGNAL CounterValue : std_logic_vector (7 DOWNTO 0);
  SIGNAL CounterRT : std_logic_vector (8 DOWNTO 0);
  SIGNAL PWMmode : std_logic_vector (1 DOWNTO 0);
  SIGNAL PWMsignal, RTsignal : std_logic;
BEGIN

    -- set/rest or reset/set mode
    PWMmode <= ALUFN_i(1 downto 0);

    -- counter process
    process (CLK, RST, ENA)
    begin
        -- asynchronous reset
        if (RST = '1') then
            CounterValue <= (others => '0');
        elsif (rising_edge(CLK) and ENA = '1') then
	    if (CounterValue >= Y_i-1) then
		CounterValue <= (others => '0');
	    else
            	CounterValue <= CounterValue + 1;
	    end if;
        end if;
    end process;

    -- counter process RT
    process (CLK, RST, ENA)
    variable temp : STD_LOGIC := '0';
    begin
        -- asynchronous reset
        if (RST = '1') then
            CounterRT <= (others => '0');
        elsif (rising_edge(CLK) and ENA = '1') then
	    if (CounterRT = X_i-1) then
		temp := not temp;
		CounterRT <= CounterRT + 1;
	    elsif (CounterRT >= Y_i-1) then
		CounterRT <= (others => '0');
	    else
            	CounterRT <= CounterRT + 1;
	    end if;
        end if;
	RTsignal <= temp;
    end process;

   
    PWMsignal <= '0' when CounterValue < X_i else
		 '1' when CounterValue >= X_i and CounterValue < Y_i else
		 '0' when CounterValue >= Y_i;

    -- output assignment
   with PWMmode select 
    PWMout <=  PWMsignal WHEN "00", 
               (NOT PWMsignal) WHEN "01", 
		RTsignal WHEN "10", 
               '0' WHEN OTHERS;
             
END struct;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

ENTITY TimerOutputUnit IS
	PORT( BTCCR0: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         BTOUTEN, BTOUTMD: IN STD_LOGIC;
         counter: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         PWMout: OUT STD_LOGIC);
END TimerOutputUnit;

ARCHITECTURE behav OF TimerOutputUnit IS
    SIGNAL PWM: STD_LOGIC;
BEGIN
    process (counter) begin
        if BTOUTEN = '1' then
            if counter <= BTCCR0 then
                PWM <= '0';    
            else
                PWM <= '1';
            end if;
        end if;
    end process;

    PWMout <= PWM when BTOUTMD = '0' else not PWM;
END behav;
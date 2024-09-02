library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity TimerOutputUnit is
    port(
        BTCCR1   : in std_logic_vector(31 downto 0);
        BTOUTEN  : in std_logic;
        BTOUTMD  : in std_logic;
        counter  : in std_logic_vector(31 downto 0);
        PWMout   : out std_logic
    );
end TimerOutputUnit;

architecture behavior of TimerOutputUnit is
    signal PWM: std_logic := '0';
begin
    process (counter) 
    begin
        if BTOUTEN = '1' then
            if unsigned(counter) <= unsigned(BTCCR1) then
                PWM <= '0';    
            else
                PWM <= '1';
            end if;
        else
            PWM <= '0';  
        end if;
    end process;
    
    
    with BTOUTMD select
        PWMout <= PWM     when '0',  
                  not PWM when '1', 
                  '0'     when others;  
    
end behavior;

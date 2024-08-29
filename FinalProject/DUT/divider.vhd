library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Use this package for numeric operations

entity divider is 
    port (
        divclk: in std_logic;
        enable: in std_logic;
        rst: in std_logic;
        dividend: in std_logic_vector(31 downto 0);
        divisor: in std_logic_vector(31 downto 0);
        quotient: out std_logic_vector(31 downto 0);
        residue: out std_logic_vector(31 downto 0);
        set_divifg: out std_logic
    );
end divider;

architecture bhv of divider is
    type state_type is (IDLE, LOAD, DIVIDE, DONE,DONE2);
    signal state : state_type := IDLE;
    signal divdendreg: std_logic_vector(63 downto 0);
    signal divsereg: std_logic_vector(31 downto 0);
    signal residuereg: std_logic_vector(31 downto 0);
    signal clkcnt : unsigned(6 downto 0) := (others => '0'); -- Counter up to 32
    signal quotientreg: std_logic_vector(31 downto 0);
    
begin
    
    process(divclk, rst)
    variable tmp :std_logic_vector(63 downto 0);
    begin
        if rst = '1' then
            state <= IDLE;
            set_divifg <= '0';
            residuereg <= (others => '0');
            quotientreg <= (others => '0');
            divdendreg <= (others => '0');
            divsereg <= (others => '0');
            clkcnt <= (others => '0');
        elsif rising_edge(divclk) then
            case state is
                when IDLE =>
                    set_divifg <= '0';
                    if enable = '1' then
                        state <= LOAD;
                    end if;

                when LOAD =>
                    divdendreg <= x"00000000" & dividend;
                    divsereg <= divisor;
                    residuereg <= (others => '0');
                    quotientreg <= (others => '0');
                    clkcnt <= (others => '0');
                    state <= DIVIDE;

                when DIVIDE =>
                    if clkcnt = 32 then
                        state <= DONE;
                    else
                        -- Shift dividend left by 1 bit
                        tmp := std_logic_vector(shift_left(unsigned(divdendreg), 1));
                        
                        -- Perform subtraction if possible
                        if unsigned(tmp(63 downto 32)) >= unsigned(divsereg) then
                            divdendreg <= std_logic_vector(unsigned(tmp(63 downto 32))-unsigned(divsereg)) & tmp(31 downto 0);
                            quotientreg <= quotientreg(30 downto 0) & '1';
                        else
                            divdendreg<= tmp;
                            quotientreg <= quotientreg(30 downto 0) & '0';
                        end if;

                        clkcnt <= clkcnt + 1;
                        state <= DIVIDE;
                    end if;

                when DONE =>
                    set_divifg <= '1'; -- Set flag to indicate completion
                    state <= IDLE;
                    quotient <= quotientreg;
                    residue <= divdendreg(63 downto 32);
                when DONE2 =>
                    set_divifg <= '0'; -- Set flag to indicate completion
            end case;
        end if;
    end process;

    -- Output assignments
   
end bhv;

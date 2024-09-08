library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aux_package.all;

entity ClockDivider is
    Port (
        clk  : in  std_logic; -- Input clock
        clk_out2 : out std_logic; -- Output clock at half frequency
        clk_out4 : out std_logic; -- Output clock at 1/4 frequency
        clk_out8 : out std_logic  -- Output clock at 1/8 frequency
    );
end ClockDivider;

architecture Behavioral of ClockDivider is
    signal counter : std_logic_vector(2 downto 0) := "000"; -- 3-bit counter
begin

    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;

    clk_out2 <= counter(0); -- Divide by 2
    clk_out4 <= counter(1); -- Divide by 4
    clk_out8 <= counter(2); -- Divide by 8

end Behavioral;

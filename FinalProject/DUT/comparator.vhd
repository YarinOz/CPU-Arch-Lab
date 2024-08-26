library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity comparator is
    port(
        clk : in std_logic;
        rst : in std_logic;
        en: in std_logic;
        BTCNT : in std_logic_vector(31 downto 0);
        BTCLO : in std_logic_vector(31 downto 0);
        CLKEDBTCNT : out std_logic_vector(31 downto 0)
    );
end comparator;

architecture behav of comparator is
    signal PLUS1 : std_logic_vector(31 downto 0);
begin
    PLUS1 <= std_logic_vector(unsigned(BTCNT) + 1);
    process(clk, rst) begin
        if rst = '1' then
            CLKEDBTCNT <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if (BTCLO <= CLKEDBTCNT) then
                    CLKEDBTCNT <= (others => '0');
                else
                    CLKEDBTCNT <= PLUS1;
                end if;
            end if;
        end if;
    end process;
end behav;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Use this package for numeric operations
use work.aux_package.all;

entity dividerEnv is
    port (
        rst, clk : in std_logic;
        MemWrite, MemRead : in std_logic;
        addressbus : in std_logic_vector(11 downto 0);
        databus : inout std_logic_vector(31 downto 0);
        set_divifg : out std_logic
    );
end dividerEnv;

architecture behav of dividerEnv is
    signal divisor : std_logic_vector(31 downto 0);
    signal dividend : std_logic_vector(31 downto 0);
    signal quotient : std_logic_vector(31 downto 0);
    signal residue : std_logic_vector(31 downto 0);
    -- signal databusin : std_logic_vector(31 downto 0);
    signal databusout : std_logic_vector(31 downto 0);
    signal writebusEn : std_logic;
    signal global_en : std_logic;
    signal divisionen : std_logic;
    signal divisor_ready, divifg: std_logic;
    constant zeroes:  std_logic_vector(31 downto 0) := (others => '0');
begin
    divisor_ready <= '1' when divisor /= zeroes else '0';
    global_en <= writebusEn and MemRead;
    -- Address decoding for read operations
    with addressbus select
        databusout <= divisor when x"830",
                     dividend when x"82C",
                     quotient when x"834",
                     residue when x"838",
                     (others => 'Z') when others;

    -- Enable signal for write operations
    with addressbus select
        writebusEn <= '1' when x"82C",
        '1' when x"830" ,
         '1' when x"834" ,
         '1' when x"838",
        '0' when others;
    
    databus <= databusout when global_en = '1' else (others => 'Z');
    set_divifg <= divifg;
    -- Bidirectional pin interface
    
    -- Write to divisor
    process(clk, rst)
    begin
        if rst = '1' then
            divisor <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' and addressbus = x"830" then
                divisor <= databus;
            end if; 
        elsif falling_edge(clk) then
            if divifg = '1' then
                divisor <= (others => '0');
            end if;
        end if;
    end process;

    -- Write to dividend
    process(clk, rst)
    begin
        if rst = '1' then
            dividend <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' and addressbus = x"82C" then
                dividend <= databus;
            end if;
        end if;
    end process;

    -- Divider component instantiation
    dividor: divider port map(
        divclk => clk,
        enable => divisor_ready,
        rst => rst,
        dividend => dividend,
        divisor => divisor,
        quotient => quotient,
        residue => residue,
        set_divifg => divifg
    );

end behav;

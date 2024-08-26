library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
entity comparatorEnv is
    port(
        rst, clk: in std_logic;
        MemWrite, MemRead: in std_logic;
        addressbus: in std_logic_vector(11 downto 0);
        databus: inout std_logic_vector(31 downto 0);
        PWMout: out std_logic;
        set_BTIFG: out std_logic
    );
end comparatorEnv;

architecture comparatorEnv of comparatorEnv is
    signal BTCCR0 ,BTCCR1 :std_logic_vector(31 downto 0);
    signal BTCTL :std_logic_vector(7 downto 0);
    signal BTCNT :std_logic_vector(31 downto 0 );
    signal CLKEDBTCNT :std_logic_vector(31 downto 0);
    signal writebusEn :std_logic;
    signal databusin :std_logic_vector(31 downto 0);
    signal databusout :std_logic_vector(31 downto 0);
    signal clk_2 :std_logic;
    signal clk_4 :std_logic;
    signal clk_8 :std_logic;
    signal counterclk :std_logic;

begin
    with addressbus select       
        writebusEn <= '1' when x"820",
                    '1' when x"824",
                    '1' when x"828",
                    '1' when x"81C",
                    '0' when others;

    with addressbus select
        databusout <= BTCCR0 when x"824",
                    BTCCR1 when x"828",
                    BTCTL when x"81C",
                    BTCNT when x"820",
                    (others => '0') when others;
    with BTCTL( 4 downto 3) select
    counterclk <= clk when "00",
                    clk_2 when "01",
                    clk_4 when "10",
                    clk_8 when "11";

    databusinout: BidirPin port map(
        Dout => databusout,
        en => writebusEn and MemRead,
        Din => databusin,
        IOPin => databus
    );
    with BTCTL(2 downto 0) select
    set_BTIFG <= BTCNT(0) when "000",
                 BTCNT(3) when "001",
                 BTCNT(7) when "010",
                 BTCNT(11) when "011",
                 BTCNT(15) when "100",
                 BTCNT(19) when "101",
                 BTCNT(23) when "110",
                 BTCNT(25) when others;


    process(clk, rst) begin
        if rst = '1' then
            BTCTL <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                if addressbus = x"81C" then
                    BTCTL <= databusin(7 downto 0);
                end if;
            end if;
        end if;
    end process;

    process(clk, rst) begin
        if rst = '1' then
            BTCNT <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                if addressbus = x"820" then
                    BTCNT <= databusin;
                else
                    BTCNT<=CLKEDBTCNT;
                end if;
             else
                BTCNT<=CLKEDBTCNT;   
            end if;
        end if;
    end process;

    process(clk, rst) begin
        if rst = '1' then
            BTCCR0 <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                if addressbus = x"824" then
                    BTCCR0 <= databusin;
                end if;
            end if;
        end if;
    end process;


    process(clk, rst) begin
        if rst = '1' then
            BTCCR1 <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                if addressbus = x"828" then
                    BTCCR1 <= databusin;
                end if;
            end if;
        end if;
    end process;

    clockdiv: ClockDivider port map(
        clk => clk,
        clk_2 => clk_2,
        clk_4 => clk_4,
        clk_8 => clk_8
    );

    comperator: comparator port map(
        clk => counterclk,
        rst => rst,
        en => not BTCTL(5),
        BTCNT => BTCNT,
        BTCLO => BTCR0,
        CLKEDBTCNT => CLKEDBTCNT
    );
    pwmoutput: TimerOutputUnit port map(
        BTCCR0 => BTCCR0,
    BTOUTEN => BTCTL(6),
    BTOUTMD => BTCTL(7),
    timer => BTCNT,
    PWMout => PWMout);
    
end comparatorEnv;

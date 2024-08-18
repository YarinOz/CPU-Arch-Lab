library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

------------------ MCU -------------------
-- This entity is the top level entity for the MCU
-- It contains the following:
-- 1. MIPS CPU core
-- 2. IO Controller
-- 3. Interrupt Controller
-- 4. Basic Timer
-- 5. Division Unit
-- 6. UART (optional)
------------------------------------------
entity MCU is
    generic(Dwidth: integer := 32;
            Awidth: integer := 8;
            Cwidth: integer := 16;
            Regwidth: integer := 8;
            IRQSize : integer := 7;
            sim: boolean := true
    );
    port(clk,rst, ena: in std_logic;
         SW : in std_logic_vector(9 downto 0);
         KEY0, KEY1, KEY2, KEY3 : in std_logic;
         HEX0,HEX1,HEX2,HEX3,HEX4,HEX5: out std_logic_vector(7 downto 0);
         LEDs: out std_logic_vector(9 downto 0);
         BTOUT: out std_logic;
         DivRES, DivQUO: out std_logic_vector(31 downto 0)
    );

end MCU;

architecture behav of MCU is
    signal Address: std_logic_vector(Awidth-1 downto 0);
    signal Control: std_logic_vector(15 downto 0);
    signal Data: std_logic_vector(Dwidth-1 downto 0);
    signal PLL_CLK: std_logic;

    -- division unit interface
    signal DIVIFG: std_logic;
    signal DivIn1, DivIn2, DivOut1, DivOut2: std_logic_vector(31 downto 0);

    component PLL is
		port (
            refclk   : in  std_logic := '0'; --  refclk.clk
            rst      : in  std_logic := '0'; --   reset.reset
            outclk_0 : out std_logic;        -- outclk0.clk
            locked   : out std_logic         --  locked.export
        );
	end component PLL;

begin

MCLK: PLL port map(
    refclk => clk,
    outclk_0 => PLL_CLK
);

MIPS_CORE: CPU 
    generic map(
        Dwidth => Dwidth,
        Awidth => Awidth,
        Regwidth => Regwidth,
        sim => sim
    )
    port map(
        clk => PLL_CLK,
        rst => rst,
        ena => ena,
        AddressBus => Address,
        ControlBus => Control,
        DataBus => Data
    );

GPIO: IO_Controller
    generic map(
        ControlBusWidth => 16,
        AddressBusWidth => 8,
        DataBusWidth => 32
    )
    port map(
        clk => PLL_CLK,
        rst => rst,
        MemReadBus => Control(0),
        MemWriteBus => Control(1),
        AddressBus => Address,
        DataBus => Data,
        SW => SW,
        HEX0 => HEX0,
        HEX1 => HEX1,
        HEX2 => HEX2,
        HEX3 => HEX3,
        HEX4 => HEX4,
        HEX5 => HEX5,
        LEDs => LEDs
    );

DIV: divider
    port map(
        divclk => PLL_CLK,
        enable => ena,
        rst => rst,
        dividend => DivIn1,
        divisor => DivIn2,
        quotient => DivQUO,
        residue => DivRES,
        divflg => DIVIFG
    );
-- add submodules and HW accelerators here    


end behav;
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
         HEX0,HEX1,HEX2,HEX3,HEX4,HEX5: out std_logic_vector(6 downto 0);
         LEDs: out std_logic_vector(7 downto 0);
         BTOUT: out std_logic
    );

end MCU;

architecture behav of MCU is
    signal Address: std_logic_vector(Dwidth-1 downto 0);
    signal Control: std_logic_vector(15 downto 0);
    signal DataOut: std_logic_vector(Dwidth-1 downto 0);
    signal DataIn: std_logic_vector(Dwidth-1 downto 0);

begin

MIPS_CORE: CPU 
    generic map(
        Dwidth => Dwidth,
        Awidth => Awidth,
        Regwidth => Regwidth,
        sim => sim
    )
    port map(
        clk => clk,
        rst => rst,
        ena => ena,
        AddressBus => Address,
        ControlBus => Control,
        DataBus => DataOut
    );
-- add submodules and HW accelerators here    


end behav;
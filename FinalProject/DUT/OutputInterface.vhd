library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use work.aux_package.all;

entity OutputInterface is
    generic (SevenSegment: boolean;
             Size: integer); 
    port (clk, rst, ChipSelect, MemRead, MemWrite: in std_logic;
            RWData: inout std_logic_vector(Size-1 downto 0);
            IO_Out : out std_logic_vector(Size-1 downto 0)); -- 7 for 7-segment display, 10 for LEDs
end OutputInterface;
-- Architecture
architecture struct of OutputInterface is
    signal AUXREG: std_logic_vector(Size-1 downto 0);
begin

    process(clk, rst)
    begin
        -- Asynchronous reset
        if rst = '1' then
            -- Initialize the output
            AUXREG <= (others => '0');
        elsif rising_edge(clk) then
            if (ChipSelect = '1' and MemWrite = '1') then
                -- Write data to the output
                AUXREG <= RWData;
            end if;
        end if;
    end process;

    -- Read data from the output (if needed)
    RWData <= AUXREG when (ChipSelect = '1' and MemRead = '1') else (others => 'Z');

    -- Generate the output
    SEVSEG: if (SevenSegment = true) generate
                -- 7-segment display
                SevenSegmentDisplay: SegmentDecoder
                    port map (data => AUXREG(3 downto 0), seg => IO_Out); -- 7 bit output (trunked)
            end generate SEVSEG;

    LEDS:   if (SevenSegment = false) generate
                -- LEDs
                IO_Out <= AUXREG;
            end generate LEDS;

end struct;


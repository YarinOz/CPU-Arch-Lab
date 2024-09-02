library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use work.aux_package.all;

entity InputInterface is
    generic (DataBusWidth: integer := 32); 
    port (ChipSelect, MemRead: in std_logic;
            RData: out std_logic_vector(DataBusWidth-1 downto 0);
            IO_In : IN std_logic_vector(8 downto 0)); 
end InputInterface;
-- Architecture
-- transfer data from IO to the CPU
architecture struct of InputInterface is
begin

    -- Read data from the input
    RData <= "00000000000000000000000" & IO_In when (ChipSelect = '1' and MemRead = '1') else (others => 'Z');

end struct;


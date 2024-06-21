LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
    GENERIC (Dwidth : INTEGER := 16);
	PORT (x, y: IN std_logic_vector(Dwidth-1 DOWNTO 0);
              mode: IN std_logic_vector(3 DOWNTO 0);
			  s: OUT std_logic_vector(Dwidth-1 DOWNTO 0));
END LOGIC;
--------------------------------------------------------
ARCHITECTURE boolean OF LOGIC IS
    SIGNAL zeros : std_logic_vector(Dwidth-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    s <= y AND x WHEN mode = "0010" ELSE
         y OR x WHEN mode = "0011" ELSE
         y XOR x WHEN mode = "0100" ELSE
         y NOR x WHEN mode = "0101" ELSE
         y NAND x WHEN mode = "0110" ELSE
         zeros;
END boolean;


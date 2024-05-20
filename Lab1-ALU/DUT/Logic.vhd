LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
    GENERIC (n: INTEGER := 8);
	PORT (x, y: IN std_logic_vector(n-1 DOWNTO 0);
              mode: IN std_logic_vector(2 DOWNTO 0);
			  s: OUT std_logic_vector(n-1 DOWNTO 0));
END LOGIC;
--------------------------------------------------------
ARCHITECTURE boolean OF LOGIC IS
    SIGNAL zeros : std_logic_vector(n-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    s <= NOT y WHEN mode = "000" ELSE
         y OR x WHEN mode = "001" ELSE
         y AND x WHEN mode = "010" ELSE
         y XOR x WHEN mode = "011" ELSE
         y NOR x WHEN mode = "100" ELSE
         y NAND x WHEN mode = "101" ELSE
         y XNOR x WHEN mode = "111" ELSE
         zeros;
END boolean;


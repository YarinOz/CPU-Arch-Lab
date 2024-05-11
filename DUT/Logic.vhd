LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
    GENERIC (n: INTEGER := 8);
	PORT (x, y: IN std_logic_vector(n-1 DOWNTO 0);
              m: IN std_logic_vector(2 DOWNTO 0);
			  s: OUT std_logic_vector(n-1 DOWNTO 0));
END LOGIC;
--------------------------------------------------------
ARCHITECTURE boolean OF LOGIC IS
    SIGNAL m: std_logic_vector(2 DOWNTO 0);
    SIGNAL zeros : std_logic_vector(n-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    s <= NOT y WHEN m = "000" ELSE
         y OR x WHEN m = "001" ELSE
         y AND x WHEN m = "010" ELSE
         y XOR x WHEN m = "011" ELSE
         y NOR x WHEN m = "100" ELSE
         y NAND x WHEN m = "101" ELSE
         y XNOR x WHEN m = "110" ELSE
         zeros;
END boolean;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Shifter IS
    GENERIC (n: INTEGER := 8);
	PORT (x, y : IN std_logic_vector(n-1 DOWNTO 0);
          dir: IN std_logic;
		  cout: OUT std_logic;
          res : OUT std_logic_vector(n-1 DOWNTO 0));
END Shifter;
--------------------------------------------------------
ARCHITECTURE SingBarShif OF Shifter IS
BEGIN
	s <= xi XOR yi XOR cin;
	cout <= (xi AND yi) OR (xi AND cin) OR(yi AND cin);
END SingBarShif;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Shifter IS
    GENERIC (n: INTEGER := 8);
	PORT (x, y : IN std_logic_vector(n-1 DOWNTO 0); -- shift y x times
          dir: IN std_logic;	-- 0: left, 1: right
		  cout: OUT std_logic;
          res : OUT std_logic_vector(n-1 DOWNTO 0));
END Shifter;
--------------------------------------------------------
ARCHITECTURE BarShif OF Shifter IS
	SIGNAL jump: INTEGER := 1;
	SUBTYPE vector IS std_logic_vector(n-1 DOWNTO 0);
	TYPE matrix is ARRAY (k-1 DOWNTO 0) OF vector; -- log2n x n
	SIGNAL STEP: matrix;
	SIGNAL carry: std_logic_vector(k-1 DOWNTO 0);
BEGIN
	STEP(0) <= y WHEN dir = '0' ELSE reverse(y);
	loop1: for j in 1 to k-1 generate
		loop2: for i in 0 to n-1 generate
			STEP(j)(i) <= STEP(j-1)(i) WHEN x(j)='0' ELSE -- no shift
				carry(j)<=STEP(j-1)(n-1); -- save carry
				STEP(j-1)(i-jump) WHEN (i-jump)>=0 ELSE '0';
		END generate loop2;
		jump <= jump*2;
	END generate loop1;
	res <= STEP(k-1) WHEN dir = '0' ELSE reverse(STEP(k-1));
	cout <= '0' WHEN carry = (OTHERS => '0') ELSE '1';
END BarShif;
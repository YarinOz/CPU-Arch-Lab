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
ARCHITECTURE BarShift OF Shifter IS
	SIGNAL jump: INTEGER := 1;
	SUBTYPE vector IS std_logic_vector(n-1 DOWNTO 0);
	TYPE matrix is ARRAY (k-1 DOWNTO 0) OF vector; -- log2n x n
	SIGNAL STEP: matrix;
	SIGNAL carry: std_logic_vector(k-1 DOWNTO 0);
BEGIN
	first: for i in 0 to n-1 generate  -- initialize
		STEP(0)(i) <= y(i) WHEN dir = '0' ELSE y(n-1-i);
	END generate first;

	zeroloop: for i in 1 to k-1 generate  -- zero fill
		STEP(i)(2**(i-1) downto 0) <= (OTHERS => '0');
	END generate zeroloop;

	looprow: for j in 1 to k-1 generate	-- 
		loopcol: for i in 0 to n-1 generate
			STEP(j)(i) <= STEP(j-1)(i) WHEN x(j)='0' ELSE -- no shift
				STEP(j-1)(i-jump) WHEN (i-jump)>=0 ELSE '0';
				carry(j)<=STEP(j-1)(n-1); -- save carry
		END generate loopcol;
		jump <= jump*2;
	END generate looprow;

	final: for i in 0 to n-1 generate 
		res(i) <= STEP(k-1)(i) WHEN dir = '0' ELSE STEP(k-1)(n-1-i);
	END generate final;

	cout <= '0' WHEN carry = (OTHERS => '0') ELSE '1';
END BarShift;
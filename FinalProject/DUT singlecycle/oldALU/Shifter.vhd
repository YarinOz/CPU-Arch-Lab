LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Shifter IS
    GENERIC (n: INTEGER := 16; -- number of bits
			 k: INTEGER := 4); -- log2(n)
	PORT (x, y : IN std_logic_vector(n-1 DOWNTO 0); -- shift y x times
          dir: IN std_logic;	-- 0: left, 1: right
		  cout: OUT std_logic;
          res : OUT std_logic_vector(n-1 DOWNTO 0));
END Shifter;
--------------------------------------------------------
ARCHITECTURE BarShift OF Shifter IS
	SUBTYPE vector IS std_logic_vector(n-1 downto 0);
	TYPE matrix is ARRAY (k downto 0) OF vector; -- log2n x n
	SIGNAL STEP: matrix;
	SIGNAL carry: std_logic_vector(k-1 downto 0);
BEGIN
	first: for i in 0 to n-1 generate  -- initialize first layer
		STEP(0)(i) <= y(i) when dir = '0' else y(n-1-i);
	end generate first;

	shift: for i in 1 to k generate  -- zero fill
		-- add zeroes if x(i) = 1, else copy [2^(i-1)-1:0]
		STEP(i)((2**(i-1) - 1) downto 0) <= STEP(i-1)((2**(i-1) - 1) downto 0)
		when  x(i-1)='0' else (others => '0');
		-- copy if x(i) = 0, else shift [n-1:2^(i-1)]
		STEP(i)(n-1 downto (2**(i-1))) <= STEP(i-1)(n-1 downto (2**(i-1))) 
		when  x(i-1)='0' else STEP(i-1)(n-1-(2**(i-1)) downto 0);

	end generate shift;
	-- carry
	carry(0) <= STEP(0)(n-1) when x(0) = '1' else '0';
	carryloop: for i in 1 to k-1 generate -- carry propagation  
			carry(i) <= STEP(i)(n-(2**(i))) when x(i) = '1' else carry(i-1);
	end generate carryloop;

	final: for i in 0 to n-1 generate -- final layer, reverse if subtracting, else 0
		res(i) <= STEP(k)(i) when dir = '0' else 
				  STEP(k)(n-1-i) when dir = '1' else
				  '0'; 
	end generate final;

	cout <= carry(k-1) when (dir = '0' or dir = '1') else '0';

end BarShift;
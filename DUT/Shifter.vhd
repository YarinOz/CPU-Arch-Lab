LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Shifter IS
    GENERIC (n: INTEGER := 8; -- number of bits
			 k: INTEGER := 3); -- log2(n)
	PORT (x, y : IN std_logic_vector(n-1 DOWNTO 0); -- shift y x times
          dir: IN std_logic;	-- 0: left, 1: right
		  cout: OUT std_logic;
          res : OUT std_logic_vector(n-1 DOWNTO 0));
END Shifter;
--------------------------------------------------------
ARCHITECTURE BarShift OF Shifter IS
	SUBTYPE vector IS std_logic_vector(n-1 downto 0);
	TYPE matrix is ARRAY (k-1 downto 0) OF vector; -- log2n x n
	SIGNAL STEP: matrix;
	SIGNAL carry: std_logic_vector(k-1 downto 0);
	SIGNAL zero_vector : std_logic_vector(k-1 downto 0) := (OTHERS => '0');
BEGIN
	first: for i in 0 to n-1 generate  -- initialize first layer
		STEP(0)(i) <= y(i) when dir = '0' else y(n-1-i);
	end generate first;

	shift: for i in 1 to k-1 generate  -- zero fill
		-- add zeroes if x(i) = 1, else copy [2^(i-1)-1:0]
		STEP(i)((2**(i-1) - 1) downto 0) <= STEP(i-1)((2**(i-1) - 1) downto 0)
		when  x(i)='0' else (others => '0');
		-- copy if x(i) = 0, else shift [n-1:2^(i-1)]
		STEP(i)(n-1 downto (2**(i-1))) <= STEP(i-1)(n-1 downto (2**(i-1))) 
		when  x(i)='0' else STEP(i-1)(n-1-(2**(i-1)) downto 0);
		-- carry
		carry(i) <= '0' when x(i)='0' else STEP(i-1)(n-1);
	end generate shift;

	final: for i in 0 to n-1 generate 
		res(i) <= STEP(k-1)(i) when dir = '0' else STEP(k-1)(n-1-i);
	end generate final;

	cout <= '0' when carry = zero_vector else '1';
end BarShift;
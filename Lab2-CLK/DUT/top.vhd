LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	
begin
	
	process1: process(clk,rst)

	end process process1;

	process2: process(clk,rst)

	end process process2;

	process3: process(clk,rst)

	end process process3;
				
	
	
	
end arc_sys;








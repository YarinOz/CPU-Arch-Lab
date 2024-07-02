library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component ALU is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,OF_flag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	COMPONENT AdderSub IS
	GENERIC (n: INTEGER := 8);
	PORT (x, y: IN std_logic_vector(n-1 DOWNTO 0);
			sub_c : IN std_logic;
			s: OUT std_logic_vector(n-1 DOWNTO 0);
			cout: OUT std_logic);
	END COMPONENT;
---------------------------------------------------------	
	COMPONENT LOGIC IS
	GENERIC (n: INTEGER := 8);
	PORT (x, y: IN std_logic_vector(n-1 DOWNTO 0);
				mode: IN std_logic_vector(2 DOWNTO 0);
				s: OUT std_logic_vector(n-1 DOWNTO 0));
	END COMPONENT;
---------------------------------------------------------	
	COMPONENT Shifter IS
    GENERIC (n: INTEGER := 8; 
			 k: INTEGER := 3); 
	PORT (x, y : IN std_logic_vector(n-1 DOWNTO 0);
			dir: IN std_logic_vector(2 DOWNTO 0);
			cout: OUT std_logic;
			res : OUT std_logic_vector(n-1 DOWNTO 0));
	END COMPONENT;
---------------------------------------------------------	
	
end aux_package;


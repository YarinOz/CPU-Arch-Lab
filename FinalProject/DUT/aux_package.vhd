library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

---------------------------------------------------------
	component TopEntity is
	GENERIC (
		n : INTEGER := 8;
		k : integer := 3;   -- k=log2(n)
		m : integer := 4    -- m=2^(k-1)
	);
	PORT (
		ENA, RST, CLK : IN STD_LOGIC;
		Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o, Cflag_o, Zflag_o, OF_flag_o, PWMout : OUT STD_LOGIC 
	);
	end component;
	---------------------------------------------------------
	component TOP_IO_Interface is
	GENERIC (HEX_num : integer := 7;
			n : INTEGER := 8);
	PORT (
		clk, rst, ena : IN std_logic; -- for single tap
		SW_i : IN std_logic_vector(n-1 downto 0);
		KEY0, KEY1, KEY2 : IN std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: OUT std_logic_vector(HEX_num-1 downto 0);
		LEDs : OUT std_logic_vector(9 downto 0)  
	);
	end component;
	---------------------------------------------------------
	component SegmentDecoder is
	GENERIC (n : INTEGER := 4;
			SegmentSize : integer := 7);
	PORT (data : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			seg : OUT STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
	end component;
	---------------------------------------------------------
	component Fmax is
	GENERIC (
		n : INTEGER := 8;
		k : integer := 3;   -- k=log2(n)
		m : integer := 4    -- m=2^(k-1)
	);
	PORT (
		clk : IN STD_LOGIC;
		Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o, Cflag_o, Zflag_o, OF_flag_o : OUT STD_LOGIC 
	); -- Zflag, Cflag, Nflag, Vflag
	end component;
---------------------------------------------------------
	component counter is
	PORT (clk,enable : IN std_logic;
		  q : OUT std_logic);
	end component;
---------------------------------------------------------
	component counterEnvelope is
	PORT (Clk,En : IN std_logic;
		  Qout : OUT std_logic);
	end component;
---------------------------------------------------------
	component PWM is
	GENERIC (n : INTEGER := 8);
	PORT (Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			CLK,ENA,RST : IN STD_LOGIC;
			PWMout : OUT STD_LOGIC);
	END COMPONENT;
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


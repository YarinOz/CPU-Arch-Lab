LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	-- signal declaration
	SIGNAL Addout,Shiftout,Logicout,extended_ALUFN_i: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL Nflag,Cflag,Zflag,Vflag: STD_LOGIC;
	BEGIN
		extended_ALUFN_i <= (others => ALUFN_i(1)); -- extend ALUFN_i(1) to n bits
		-- component instantiation
	Adder: AdderSub PORT MAP(
        sub_c => ALUFN_i(0) OR ALUFN_i(1), --sub "001","010"
        cin => ALUFN_i(0) OR ALUFN_i(1),
        x => X_i,
        y => Y_i AND NOT extended_ALUFN_i, -- 0 -> 0 , 1 -> Y
        s => Addout,
        cout => Cflag
		Zflag_o <= '1' WHEN Addout = (OTHERS => '0') ELSE '0';
		Nflag_o <= Addout(n-1);
		Vflag_o <= NOT(ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1)) OR
					(NOT X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1))) OR 
					(ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1)) OR
					(NOT X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1)));
    	);

    LogicUnit: LOGIC PORT MAP(
        x => X_i,
        y => Y_i,
		m => ALUFN_i(2 DOWNTO 0),
        s => Logicout
		Vflag_o <= '0';
		Nflag_o <= Logicout(n-1);
		Zflag_o <= '1' WHEN Logicout = (OTHERS => '0') ELSE '0';
		Cflag_o <= '0';
    	);

    ShifterUnit: Shifter PORT MAP(
        x => X_i,
        y => Y_i,
        dir => ALUFN_i(0),
        cout => Cflag_o,
        res => Shiftout
		Vflag_o <= '0';
		Nflag_o <= Shiftout(n-1);
		Zflag_o <= '1' WHEN Shiftout = (OTHERS => '0') ELSE '0';
    	);

	ALUout_o <=  Addout WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
					Logicout WHEN ALUFN_i(4 DOWNTO 3)="11" ELSE
					Shiftout WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE
					(OTHERS => '0');

 	END struct;
	

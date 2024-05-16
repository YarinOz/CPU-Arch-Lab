LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY top IS
  GENERIC (
    n : INTEGER := 8;
    k : integer := 3;   -- k=log2(n)
    m : integer := 4    -- m=2^(k-1)
  );
  PORT (
    Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);-- might need to create temp inputs for each component since chanan wants us to "zero" them out in case they are not being used, the realization should be done using or + and gates - same as block description 
    ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
    ALUout_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
    Nflag_o, Cflag_o, Zflag_o, OF_flag_o : OUT STD_LOGIC --might not need,check later
  ); -- Zflag, Cflag, Nflag, Vflag
END top;

ARCHITECTURE struct OF top IS
  -- signal declaration
  SIGNAL Addout, Shiftout, Logicout, extended_ALUFN_i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIgnal cout_vec :std_logic_vector(1 DOWNTO 0);-- need to check if thats the correct placement
BEGIN
  extended_ALUFN_i <= (others => ALUFN_i(1)); -- extend ALUFN_i(1) to n bits
  -- component instantiation
  Adder : AdderSub PORT MAP (
    sub_c => ALUFN_i(0) OR ALUFN_i(1), --sub "001","010" ,in case temp inputs are being used this logic needs to be changed
    cin => ALUFN_i(0) OR ALUFN_i(1),
    x => X_i,
    y => Y_i AND NOT extended_ALUFN_i, -- 0 -> 0 , 1 -> Y ,in case temp inputs are being used this logic might  need to be changeded
    s => Addout,
    cout => cout_vec(0)
  );
  --Zflag_o <= '1' WHEN Addout = (OTHERS => '0') ELSE '0';
  --Nflag_o <= Addout(n-1);
  
  LogicUnit : LOGIC PORT MAP (
    x => X_i,
    y => Y_i,
    m => ALUFN_i(2 DOWNTO 0),
    s => Logicout
	--count_vec(1)=>logicout(n-1)
  );
  --Vflag_o <= '0';
 -- Nflag_o <= Logicout(n-1);
 -- Zflag_o <= '1' WHEN Logicout = (OTHERS => '0') ELSE '0';
  --Cflag_o <= '0';
  
  ShifterUnit : Shifter PORT MAP (
    x => X_i,
    y => Y_i,
    dir => ALUFN_i(0),
    cout => cout_vec(1),-- need to change carry signal of the shifter module   from k length vector to std logic and update the algorithm
    res => Shiftout
  );
  --Nflag_o <= Shiftout(n-1);
  -- Zflag_o <= '1' WHEN Shiftout = (OTHERS => '0') ELSE '0'; 

  ALUout_o <=  Addout WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
              Logicout WHEN ALUFN_i(4 DOWNTO 3)="11" ELSE
              Shiftout WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE
              (OTHERS => '0');
  OF_flag_o <= NOT(ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1)) OR
              (NOT X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1))) OR 
              (ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1)) OR
              (NOT X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1)));
  Nflag_o <=ALUout_o(n-1);--needs to check if we can connect an output to an output
  Zflag_o <= '1' WHEN ALUout_o = (OTHERS => '0') ELSE '0';-- needs to check if we can connect an output to an output
  Cflag_o <= cout_vec(0) WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
             cout_vec(1) WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE 
             (OTHERS => '0');
             
END struct;

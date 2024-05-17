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
    Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
    ALUout_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
    Nflag_o, Cflag_o, Zflag_o, OF_flag_o : OUT STD_LOGIC 
  ); -- Zflag, Cflag, Nflag, Vflag
END top;

ARCHITECTURE struct OF top IS
  -- signal declaration
  SIGNAL AddX, AddY, LOGX, LOGY, SHX, SHY, Addout,
   Shiftout, Logicout, minus, ALUout: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL zeroes : std_logic_vector(n-1 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL cout_vec :std_logic_vector(1 DOWNTO 0);-- carry vector for the adder[0] and shifter[1]
  SIGNAL subtract, OVF : std_logic;
BEGIN
  -- input assignment (zero input if not used [HIGH Z?])
  AddX <= X_i WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE (OTHERS=>'0');
  AddY <= Y_i WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE (OTHERS=>'0');

  LOGX <= X_i WHEN ALUFN_i(4 DOWNTO 3)="11" ELSE (OTHERS=>'0');
  LOGY <= Y_i WHEN ALUFN_i(4 DOWNTO 3)="11" ELSE (OTHERS=>'0');

  SHX <= X_i WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE (OTHERS=>'0');
  SHY <= Y_i WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE (OTHERS=>'0');

  minus <= AddY WHEN ALUFN_i(1)='0' ELSE (OTHERS=>'0'); -- for neg(x)
  subtract <= ALUFN_i(0) OR ALUFN_i(1); -- subtract when ALUFN_i(0) OR ALUFN_i(1) = 1
  OVF <= (NOT (ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1)) OR
          (NOT X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1)))) OR 
          ((ALUFN_i(0) OR ALUFN_i(1)) AND ((X_i(n-1) AND NOT Y_i(n-1) AND Addout(n-1)) OR
          (NOT X_i(n-1) AND Y_i(n-1) AND NOT Addout(n-1))));

  -- component instantiation
  Adder : AdderSub 
  GENERIC MAP(n) 
  PORT MAP (
    sub_c => subtract, --sub "001","010" = 1
    x => AddX,
    y => minus, -- 1 -> 0 , 0 -> Y 
    s => Addout,
    cout => cout_vec(0)
  );
  
  LogicUnit : LOGIC 
  GENERIC MAP(n) 
  PORT MAP (
    x => LOGX,
    y => LOGY,
    mode => ALUFN_i(2 DOWNTO 0),
    s => Logicout
  );
  
  ShifterUnit : Shifter 
  GENERIC MAP(n,k) 
  PORT MAP (
    x => SHX,
    y => SHY,
    dir => ALUFN_i(0),
    cout => cout_vec(1),-- need to change carry signal of the shifter module   from k length vector to std logic and update the algorithm
    res => Shiftout
  );
  -- output assignment
  ALUout <=  Addout WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
              Logicout WHEN ALUFN_i(4 DOWNTO 3)="11" ELSE
              Shiftout WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE
              (OTHERS => '0');

  OF_flag_o <= OVF WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
               '0';
  Nflag_o <= ALUout(n-1);
  Zflag_o <= '1' WHEN ALUout = zeroes ELSE '0';
  Cflag_o <= cout_vec(0) WHEN ALUFN_i(4 DOWNTO 3)="01" ELSE
             cout_vec(1) WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE 
             '0';
  ALUout_o <= ALUout;
             
END struct;

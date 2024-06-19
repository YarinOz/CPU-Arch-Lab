LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY ALU IS
  GENERIC (
    Dwidth : INTEGER := 16;
    k : integer := 4;   -- k=log2(n)
    m : integer := 8    -- m=2^(k-1)
  );
  PORT (
    Y_i, X_i : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
    ALUFN_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    ALUout_o : OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0);
    Nflag_o, Cflag_o, Zflag_o: OUT STD_LOGIC 
  ); -- Zflag, Cflag, Nflag
END ALU;

ARCHITECTURE struct OF ALU IS
  -- signal declaration
  SIGNAL AddX, AddY, LOGX, LOGY, SHX, SHY, Addout,
   Shiftout, Logicout, ALUout: STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
  SIGNAL zeroes : std_logic_vector(Dwidth-1 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL cout_vec :std_logic_vector(1 DOWNTO 0);-- carry vector for the adder[0] and shifter[1]
  SIGNAL subtract : std_logic;
BEGIN
  -- input assignment (zero input if not used)
  AddX <= X_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'Z');
  AddY <= Y_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'Z');

  LOGX <= X_i WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE (OTHERS=>'Z');
  LOGY <= Y_i WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE (OTHERS=>'Z');

  -- SHX <= X_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'Z');
  -- SHY <= Y_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'Z');

  subtract <= '1' WHEN ALUFN_i="0001" ELSE '0'; -- subtract when OPC="0001"

  -- component instantiation
  Adder : AdderSub 
  GENERIC MAP(Dwidth) 
  PORT MAP (
    sub_c => subtract, 
    x => AddX,
    y => AddY, 
    s => Addout,
    cout => cout_vec(0)
  );
  
  LogicUnit : LOGIC 
  GENERIC MAP(Dwidth) 
  PORT MAP (
    x => LOGX,
    y => LOGY,
    mode => ALUFN_i,
    s => Logicout
  );
  
  -- AUX DATA: 01 ADDER, 10 SHIFTER, 11 LOGIC 
  -- ShifterUnit : Shifter 
  -- GENERIC MAP(Dwidth,k) 
  -- PORT MAP (
  --   x => SHX,
  --   y => SHY,
  --   dir => ALUFN_i(2 DOWNTO 0),
  --   cout => cout_vec(1),
  --   res => Shiftout
  -- );
  -- output assignment
  ALUout <=  Addout WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE
              Logicout WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE
              -- Shiftout WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE
              (OTHERS => '0');

  Nflag_o <= ALUout(Dwidth-1);
  Zflag_o <= '1' WHEN ALUout = zeroes ELSE '0';
  Cflag_o <= cout_vec(0) WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE
            --  cout_vec(1) WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE 
             '0';
  ALUout_o <= ALUout;
             
END struct;

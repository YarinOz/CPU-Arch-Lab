LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY ALU IS
  GENERIC (
    Dwidth : INTEGER := 16
    -- k : integer := 4;   -- k=log2(n)
    -- m : integer := 8    -- m=2^(k-1)
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
  SIGNAL AddX, AddY, SHX, SHY, LOGX, LOGY, Addout,
   Shiftout, Logicout, ALUout: STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
  SIGNAL zeroes : std_logic_vector(Dwidth-1 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL cout_vec :std_logic_vector(1 DOWNTO 0);-- carry vector for the adder[0] and shifter[1]
  SIGNAL subtract : std_logic;
BEGIN

  -- input assignment (zero input if not used)
  AddX <= X_i WHEN (ALUFN_i="0000" or ALUFN_i="0001" or ALUFN_i="1110" or ALUFN_i="1101") ELSE (OTHERS=>'0');
  AddY <= Y_i WHEN (ALUFN_i="0000" or ALUFN_i="0001" or ALUFN_i="1110" or ALUFN_i="1101") ELSE (OTHERS=>'0');

  LOGX <= X_i WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE (OTHERS=>'0');
  LOGY <= Y_i WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE (OTHERS=>'0');

  -- SHX <= X_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'0');
  -- SHY <= Y_i WHEN (ALUFN_i="0000" or ALUFN_i="0001") ELSE (OTHERS=>'0');

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
  
  Logicout <= LOGX AND LOGY WHEN ALUFN_i="0010" ELSE
              LOGX OR LOGY WHEN ALUFN_i="0011" ELSE
              LOGX XOR LOGY WHEN ALUFN_i="0100" ELSE
              LOGX XNOR LOGY WHEN ALUFN_i="0101" ELSE
              (OTHERS => '0');
  
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
  ALUout <=  Addout WHEN (ALUFN_i="0000" or ALUFN_i="0001" or ALUFN_i="1101" or ALUFN_i="1110") ELSE
              Logicout WHEN (ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100") ELSE
              -- Shiftout WHEN ALUFN_i(4 DOWNTO 3)="10" ELSE
              (OTHERS => '0');

  Nflag_o <= '1' when (ALUout(Dwidth-1)='1') and (ALUFN_i="0000" or ALUFN_i="0001" or ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100" or ALUFN_i="0101" or ALUFN_i="0110") else unaffected when (ALUFN_i="1110" or ALUFN_i="1101" or ALUFN_i="1111") else '0';
  Zflag_o <= '1' WHEN (ALUout = zeroes and (ALUFN_i="0000" or ALUFN_i="0001" or ALUFN_i="0010" or ALUFN_i="0011" or ALUFN_i="0100" or ALUFN_i="0101" or ALUFN_i="0110")) else unaffected when (ALUFN_i="1110" or ALUFN_i="1101" or ALUFN_i="1111") ELSE '0';
  Cflag_o <= cout_vec(0) WHEN (ALUFN_i="0000" or ALUFN_i="0001") else unaffected when (ALUFN_i="1110" or ALUFN_i="1101" or ALUFN_i="1111") ELSE '0';

  ALUout_o <= ALUout;
             
END struct;

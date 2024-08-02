LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY ALU IS
  GENERIC (
    Dwidth : INTEGER := 32; -- data width
    k : integer := 5;   -- k=log2(n)
    m : integer := 8    -- m=2^(k-1)
  );
  PORT (
    Y_i, X_i : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
    ALUFN_i : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    ALUout_o : OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0);
    Nflag_o, Cflag_o, Zflag_o: OUT STD_LOGIC 
  ); -- Zflag, Cflag, Nflag
END ALU;

ARCHITECTURE struct OF ALU IS
  -- signal declaration
  SIGNAL AddX, AddY, SHX, SHY, LOGX, LOGY, Addout,
   Shiftout, Logicout,Mulout, ALUout: STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
  SIGNAL zeroes : std_logic_vector(Dwidth-1 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL cout_vec :std_logic_vector(1 DOWNTO 0);-- carry vector for the adder[0] and shifter[1]
  SIGNAL subtract : std_logic;
  SIGNAL sltSIG : std_logic_vector(Dwidth-1 DOWNTO 0);
BEGIN

  -- input assignment (zero input if not used)
  -- add,addu,sub,addi,lw,sw,slt,slti
  AddX <= X_i WHEN (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000" or ALUFN_i="100011" or ALUFN_i="101011" or ALUFN_i="101010" or ALUFN_i="001010") ELSE (OTHERS=>'0');
  AddY <= Y_i WHEN (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000" or ALUFN_i="100011" or ALUFN_i="101011" or ALUFN_i="101010" or ALUFN_i="001010") ELSE (OTHERS=>'0');
  -- and,or,xor,xori,andi,ori
  LOGX <= X_i WHEN (ALUFN_i="100100" or ALUFN_i="100101" or ALUFN_i="100110" or ALUFN_i="001100" or ALUFN_i="001101" or ALUFN_i="001110") ELSE (OTHERS=>'0');
  LOGY <= Y_i WHEN (ALUFN_i="100100" or ALUFN_i="100101" or ALUFN_i="100110" or ALUFN_i="001100" or ALUFN_i="001101" or ALUFN_i="001110") ELSE (OTHERS=>'0');
  -- sll,srl
  SHX <= X_i WHEN (ALUFN_i="000000" or ALUFN_i="000010") ELSE (OTHERS=>'0');
  SHY <= Y_i WHEN (ALUFN_i="000000" or ALUFN_i="000010") ELSE (OTHERS=>'0');

  -- multiply
  Mulout <= X_i * Y_i WHEN (ALUFN_i="011100") ELSE (OTHERS => '0');
  
  subtract <= '1' WHEN ALUFN_i="100010" ELSE '0'; -- subtract

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
  
  Logicout <= LOGX AND LOGY WHEN (ALUFN_i="100100" or ALUFN_i="001100") ELSE
              LOGX OR LOGY WHEN (ALUFN_i="100101" or ALUFN_i="001101") ELSE
              LOGX XOR LOGY WHEN (ALUFN_i="100110" or ALUFN_i="001110") ELSE
              (OTHERS => '0');
  
  -- AUX DATA: 01 ADDER, 10 SHIFTER, 11 LOGIC 
  ShifterUnit : Shifter 
  GENERIC MAP(Dwidth,k) 
  PORT MAP (
    x => SHX,
    y => SHY,
    dir => ALUFN_i(1),
    cout => cout_vec(1),
    res => Shiftout
  );
  -- output assignment
  ALUout <=  Addout WHEN (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000" or ALUFN_i="100011" or ALUFN_i="101011" or ALUFN_i="101010" or ALUFN_i="001010") ELSE
              Logicout WHEN (ALUFN_i="100100" or ALUFN_i="100101" or ALUFN_i="100110" or ALUFN_i="001100" or ALUFN_i="001101" or ALUFN_i="001110") ELSE
              Shiftout WHEN (ALUFN_i="000000" or ALUFN_i="000010") ELSE
              Mulout WHEN (ALUFN_i="011100") ELSE
              (OTHERS => '0');

  -- flags not affected by lw,sw
  Nflag_o <= '1' when (ALUout(Dwidth-1)='1') and (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000" or ALUFN_i="101010" or ALUFN_i="001010") 
                  else unaffected when (ALUFN_i="101011" or ALUFN_i="100011") else '0';
  Zflag_o <= '1' WHEN (ALUout = zeroes and (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000" or ALUFN_i="101010" or ALUFN_i="001010")) 
                  else unaffected when (ALUFN_i="101011" or ALUFN_i="100011") else '0';
  Cflag_o <= cout_vec(0) WHEN (ALUFN_i="100000" or ALUFN_i="100001" or ALUFN_i="100010" or ALUFN_i="001000") 
                          else unaffected when (ALUFN_i="100100" or ALUFN_i="100101" or ALUFN_i="100110" or ALUFN_i="001100" or ALUFN_i="001101" or ALUFN_i="001110") 
                          else cout_vec(1) when (ALUFN_i="000000" or ALUFN_i="000010")
                          else '0';
  sltSIG <= (others => '0');
  sltSIG(0) <= Zflag_o;
  
  ALUout_o <= sltSIG when (ALUFN_i="101010" or ALUFN_i="001010") else ALUout; --slt,slti else ALUout
             
END struct;
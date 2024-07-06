LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY TopEntity IS
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
END TopEntity;

ARCHITECTURE behavior OF TopEntity IS
  
BEGIN

  ALU_inst : ALU
    GENERIC MAP (
      n => 8,
      k => 3,
      m => 4
    )
    PORT MAP (
      Y_i => Y_i,
      X_i => X_i,
      ALUFN_i => ALUFN_i,
      ALUout_o => ALUout_o,
      Nflag_o => Nflag_o,
      Cflag_o => Cflag_o,
      Zflag_o => Zflag_o,
      OF_flag_o => OF_flag_o
    );

  PWM_inst : PWM
    GENERIC MAP (
      n => 8
    )
    PORT MAP (
      Y_i => Y_i,
      X_i => X_i,
      ALUFN_i => ALUFN_i,
      CLK => CLK,
      ENA => ENA,
      RST => RST,
      PWMout => PWMout
    );


END behavior;
      

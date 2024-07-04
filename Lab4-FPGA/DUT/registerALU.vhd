LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------Top ALU Performance Test Case--------------
-- Top for testing the performance, area and functionality of the ALU
-- Because the ALY is asynchronous we need to confine the ALU between two synchronous registers
-- Note: We could use only one process but we divivde it for a better visibility
--- Measure Fmax without PLL
ENTITY Fmax IS
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
END Fmax;
------------------------------------------------
ARCHITECTURE struct OF Fmax IS 

	-- Inputs of the ALU
	signal X, Y : std_logic_vector(n-1 downto 0);  
	signal ALUFN: std_logic_vector(4 downto 0);
	-- Outputs of the ALU
	signal ALUout : std_logic_vector(n-1 downto 0);
	signal Zflag, Cflag, Nflag, OF_flag : std_logic;

BEGIN
	
	--- Inputs Register
	process (clk) 
	begin
		if rising_edge(clk) then 
			X <= X_i;
			Y <= Y_i;
			ALUFN <= ALUFN_i;
		end if;
	end process;
	
	-------------------ALU Module -----------------------------
	ALUModule:	ALU	port map(Y, X, ALUFN, ALUout, Nflag, Cflag, Zflag, OF_flag);
	-----------------------------------------------------------
	
	--- Outputs Register
	process (clk) 
	begin
		if rising_edge(clk) then 
			ALUout_o <= ALUout;
			Zflag_o <= Zflag;
			Cflag_o <= Cflag;
			Nflag_o <= Nflag;
            OF_flag_o <= OF_flag;
		end if;
	end process;	
				 
END struct;


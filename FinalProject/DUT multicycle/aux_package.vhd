library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component CPU is
	generic(Dwidth: integer := 32;
			Awidth: integer := 32;
			Regwidth: integer := 4;
			dept: integer := 64
	);
    port(clk,rst,ena: in std_logic;
		AddressBus: in std_logic_vector(Dwidth-1 downto 0);
		ControlBus: inout std_logic_vector(15 downto 0);
		DataBus: inout std_logic_vector(Dwidth-1 downto 0)
    );
	end component;

---------------------------------------------------------
	component BidirPin is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
	end component;
---------------------------------------------------------
	component BidirPinBasic is
	port(   writePin: in 	std_logic;
			readPin:  out 	std_logic;
			bidirPin: inout std_logic
	);
	end component;	
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	COMPONENT AdderSub IS
	GENERIC (Dwidth: integer := 32);
	PORT (x, y: IN std_logic_vector(Dwidth-1 DOWNTO 0);
			sub_c : IN std_logic;
			s: OUT std_logic_vector(Dwidth-1 DOWNTO 0);
			cout: OUT std_logic);
	END COMPONENT;
---------------------------------------------------------	
	COMPONENT Shifter IS
    GENERIC (Dwidth: INTEGER := 32; 
			 k: INTEGER := 4); 
	PORT (x, y : IN std_logic_vector(Dwidth-1 DOWNTO 0);
			dir: IN std_logic;
			cout: OUT std_logic;
			res : OUT std_logic_vector(Dwidth-1 DOWNTO 0));
	END COMPONENT;
---------------------------------------------------------	
	component ControlUnit IS
		PORT(
			clk: in std_logic;
			rst: in std_logic;
			opcode, funct: in std_logic_vector(5 downto 0);
			-- Control signals for the datapath
			RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: out std_logic;
			ALUop: out std_logic_vector(5 downto 0)
		);
	END component;
---------------------------------------------------------
	component Datapath is
		generic(
			Dwidth: integer := 32;
			Awidth: integer := 32;
			Regwidth: integer := 4;
			dept: integer := 64
		);
	port(	
		clk, rst: in std_logic;
		-- control signals
		RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
		ALUop: in std_logic_vector(5 downto 0);
		-- status signals
		opcode, funct: out std_logic_vector(5 downto 0)
	);
	end component;	
---------------------------------------------------------	
	component RF IS
	generic( Dwidth: integer:=32;
			Awidth: integer:=32);
		PORT(
			clk,rst,WregEn: in std_logic;	
			WregData:	in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr1, RregAddr2: in std_logic_vector(Awidth-1 downto 0);
			RregData1, RregData2: out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
---------------------------------------------------------
	component ALU is
	generic (
		Dwidth : INTEGER := 32;
		k : integer := 5;   -- k=log2(n)
		m : integer := 8    -- m=2^(k-1)
		);
		PORT(
			Y_i, X_i : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
			ALUFN_i : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			ALUout_o : OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0);
			Nflag_o, Cflag_o, Zflag_o: OUT STD_LOGIC 
		);
	end component;
---------------------------------------------------------
	component dataMem is
	generic(
		Dwidth: integer := 32;
		Awidth: integer := 32;
		dept: integer := 64
	);
	port(clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr:	in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
---------------------------------------------------------
	component progMem is
	generic(
		Dwidth: integer := 16;
		Awidth: integer := 6;
		dept: integer := 64
	);
	port(RmemAddr:	in std_logic_vector(Dwidth-1 downto 0);
		memData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
	
end aux_package;


library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
	generic(Dwidth: integer := 16;
			Awidth: integer := 6;
			Regwidth: integer := 4;
			dept: integer := 64
	);
    port(clk,rst,ena: in std_logic;
         done_FSM: out std_logic;
         -- Test bench signals
             -- program memory signals
        progMemEn: in std_logic;
        progDataIn: in std_logic_vector(Dwidth-1 downto 0);
        progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
        -- -- data memory signals
        dataMemEn, TBactive: in std_logic;
        dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
        dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
        dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
    );
	end component;

---------------------------------------------------------
	component BidirPin is
	generic( width: integer:=16 );
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
	GENERIC (Dwidth: integer := 16);
	PORT (x, y: IN std_logic_vector(Dwidth-1 DOWNTO 0);
			sub_c : IN std_logic;
			s: OUT std_logic_vector(Dwidth-1 DOWNTO 0);
			cout: OUT std_logic);
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
	component ControlUnit IS
		PORT(
			clk, rst: in std_logic;
			st, ld, mov, done, add, sub, jmp, jc, jnc, Cflag, Zflag, Nflag, andf,
			orf, xorf, un1, un2, un3, un4: in std_logic;
			Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in : out std_logic;
			PCsel, Rfaddr: out std_logic_vector(1 downto 0);
			OPC: out std_logic_vector(3 downto 0);
			ena: in std_logic;
			done_FSM : out std_logic
		);
	END component;
---------------------------------------------------------
	component Datapath is
		generic(
			Dwidth: integer := 16;
			Awidth: integer := 6;
			Regwidth: integer := 4;
			dept: integer := 64
		);
	port(	
		TBactive, clk, rst: in std_logic;
		-- control signals
		Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in :in std_logic;
		PCsel, Rfaddr: in std_logic_vector(1 downto 0);
		OPC: in std_logic_vector(3 downto 0);
		-- status signals
		st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
		orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: out std_logic;
		-- program memory signals
		progMemEn: in std_logic;
		progDataIn: in std_logic_vector(Dwidth-1 downto 0);
		progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
		-- -- data memory signals
		dataMemEn: in std_logic;
		dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
		dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
		dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;	
---------------------------------------------------------	
	component RF IS
	generic( Dwidth: integer:=16;
			Awidth: integer:=4);
		PORT(
			clk,rst,WregEn: in std_logic;	
			WregData: in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr: in std_logic_vector(Awidth-1 downto 0);
			RregData: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
---------------------------------------------------------
	component ALU is
	generic (
		Dwidth : INTEGER := 16
		-- k : integer := 4;   -- k=log2(n)
		-- m : integer := 8    -- m=2^(k-1)
		);
		PORT(
			Y_i, X_i : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
			ALUFN_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			ALUout_o : OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0);
			Nflag_o, Cflag_o, Zflag_o: OUT STD_LOGIC 
		);
	end component;
---------------------------------------------------------
	component dataMem is
	generic(
		Dwidth: integer := 16;
		Awidth: integer := 6;
		dept: integer := 64
	);
	port(clk,memEn: in std_logic;	
		WmemData: in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr: in std_logic_vector(Awidth-1 downto 0);
		RmemData: out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
---------------------------------------------------------
	component progMem is
	generic(
		Dwidth: integer := 16;
		Awidth: integer := 6;
		dept: integer := 64
	);
	port(clk,memEn: in std_logic;	
		WmemData: in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr: in std_logic_vector(Awidth-1 downto 0);
		RmemData: out std_logic_vector(Dwidth-1 downto 0)
);
	end component;
	
end aux_package;


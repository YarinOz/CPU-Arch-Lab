library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component CPU is
	generic(Dwidth: integer := 32;
			Awidth: integer := 8;
			Regwidth: integer := 8;
			sim: boolean := true
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
	component ControlUnit IS
		PORT(
			clk: in std_logic;
			rst: in std_logic;
			opcode, funct: in std_logic_vector(5 downto 0);
			-- Control signals for the datapath
			RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: out std_logic;
			ALUop: out std_logic_vector(5 downto 0);
			PCSrc: out std_logic_vector(1 downto 0)
		);
	END component;
---------------------------------------------------------
	component Datapath is
		generic(
			Dwidth: integer;
			Awidth: integer;
			Regwidth: integer;
			sim: boolean
		);
	port(	
		clk, rst, ena: in std_logic;
		-- control signals
		RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
		ALUop: in std_logic_vector(5 downto 0);
		PCSrc: in std_logic_vector(1 downto 0);
		-- status signals
		opcode, funct: out std_logic_vector(5 downto 0)
	);
	end component;	
---------------------------------------------------------	
	component RF IS
	generic( Dwidth: integer:=32;
			Awidth: integer:=5);
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
		Dwidth : INTEGER := 32
		);
		PORT(
			A, B : in std_logic_vector(Dwidth-1 downto 0);
			ALUop : in std_logic_vector(5 downto 0);
			Result : out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	---------------------------------------------------------
	component SegmentDecoder is
	GENERIC (n : INTEGER := 4;
			SegmentSize : integer := 7);
	PORT (data : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			seg : OUT STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
	end component;
	---------------------------------------------------------
	component InputInterface is
	generic (DataBusWidth: integer := 32);
	port (ChipSelect, MemRead: in std_logic;
			RData: out std_logic_vector(DataBusWidth-1 downto 0);
			IO_In : IN std_logic_vector(7 downto 0));
	end component;
	---------------------------------------------------------
	component OutputInterface is
	generic (SevenSegment: boolean := true;
			SEGSize: integer := 7;
			LEDSize: integer := 10);
	port (clk, rst, ChipSelect, MemRead, MemWrite: in std_logic;
			RWData: inout std_logic_vector(LEDSize-1 downto 0);
			IO_Out : out std_logic_vector(LEDSize-1 downto 0));
	end component;
	
end aux_package;


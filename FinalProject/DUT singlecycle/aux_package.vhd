library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component CPU is
	generic(Dwidth: integer := 32;
			Awidth: integer := 5;
			Regwidth: integer := 4;
			dept: integer := 64
	);
    port(clk,rst,ena: in std_logic;
		AddressBus: in std_logic_vector(Dwidth-1 downto 0);
		ControlBus: inout std_logic_vector(15 downto 0);
		DataBus: inout std_logic_vector(Dwidth-1 downto 0);
		-- memory init signals
		progMemEn: in std_logic;
		progDataIn: in std_logic_vector(Dwidth-1 downto 0);
		progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
		-- -- -- data memory signals
		dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
		dataWriteAddr: in std_logic_vector(Awidth-1 downto 0)
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
			ALUop: out std_logic_vector(5 downto 0)
		);
	END component;
---------------------------------------------------------
	component Datapath is
		generic(
			Dwidth: integer := 32;
			Awidth: integer := 5;
			Regwidth: integer := 4;
			dept: integer := 64
		);
	port(	
		clk, rst, init: in std_logic;
		-- control signals
		RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
		ALUop: in std_logic_vector(5 downto 0);
		-- status signals
		opcode, funct: out std_logic_vector(5 downto 0);
		-- for initial program memory
		-- program memory signals
		progMemEn: in std_logic;
		progDataIn: in std_logic_vector(Dwidth-1 downto 0);
		progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
		-- -- -- data memory signals
		dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
		dataWriteAddr: in std_logic_vector(Awidth-1 downto 0)
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
			Result : out std_logic_vector(Dwidth-1 downto 0);
			Zero : out std_logic
		);
	end component;
---------------------------------------------------------
	component dataMem is
	generic(
		Dwidth: integer := 32;
		Awidth: integer := 5;
		dept: integer := 64
	);
	port(clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr, RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
---------------------------------------------------------
	component progMem is
	generic(
		Dwidth: integer := 32;
		Awidth: integer := 5;
		dept: integer := 64
	);
	port(clk : in std_logic;
		-- Read program memory
		RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0);
		-- Write program memory
		WmemEn:   in std_logic;
		WmemAddr: in std_logic_vector(Awidth-1 downto 0);
		WmemData: in std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
	
end aux_package;


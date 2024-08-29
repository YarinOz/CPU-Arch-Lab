library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

--------------------------------------------------------
	component MCU is
	generic(Dwidth: integer := 32;
			Awidth: integer := 12;
			Cwidth: integer := 16;
			Regwidth: integer := 8;
			IRQSize : integer := 7;
			sim: boolean := true
	);
	port(clk,rst, ena: in std_logic;
		SW : in std_logic_vector(8 downto 0);
		KEY0, KEY1, KEY2, KEY3 : in std_logic;
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5: out std_logic_vector(6 downto 0);
		LEDs: out std_logic_vector(7 downto 0);
		BTOUT: out std_logic;
		DivRES, DivQUO: out std_logic_vector(31 downto 0)
	);
	end component;
--------------------------------------------------------
	component CPU is
	generic(Dwidth: integer;
			Awidth: integer;
			Regwidth: integer;
			sim: boolean
	);
    port(clk,rst,ena: in std_logic;
		AddressBus: out std_logic_vector(Awidth-1 downto 0);
		ControlBus: out std_logic_vector(15 downto 0);
		DataBus: inout std_logic_vector(Dwidth-1 downto 0);
		INTA: out std_logic;
		INTR: in std_logic
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
    opcode, funct: out std_logic_vector(5 downto 0);
    -- MEM/IO signals
    -- Busses
    AddrBus: out std_logic_vector(Awidth-1 downto 0);
    DataBus: inout std_logic_vector(Dwidth-1 downto 0);
    GIE: out std_logic;
    INTA: out std_logic;
    INTR: in std_logic
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
			RregData1, RregData2: out std_logic_vector(Dwidth-1 downto 0);
			GIE: out std_logic;
			INTR: in std_logic;
			ISR2PC: in std_logic
		);
	end component;
---------------------------------------------------------
	component ALU is
	generic (
		Dwidth : INTEGER
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
			IO_In : IN std_logic_vector(8 downto 0));
	end component;
	---------------------------------------------------------
	component OutputInterface is
	generic (SevenSegment: boolean;
			size: integer);
	port (clk, rst, ChipSelect, MemRead, MemWrite: in std_logic;
			RWData: inout std_logic_vector(size-1 downto 0);
			IO_Out : out std_logic_vector(size-1 downto 0));
	end component;
	---------------------------------------------------------
	component IO_Controller is
	GENERIC (	ControlBusWidth : integer;
				AddressBusWidth : integer;
				DataBusWidth : integer);
	PORT (-- control signals
			clk, rst, MemReadBus, MemWriteBus : in std_logic;
			-- Busses
			AddressBus : in std_logic_vector(AddressBusWidth-1 downto 0);
			DataBus : inout std_logic_vector(DataBusWidth-1 downto 0);
			-- Switch Port
			SW : in std_logic_vector(8 downto 0);
			-- 7 segment Ports
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0);
			-- Leds Port
			LEDs : out std_logic_vector(9 downto 0)
	);
	end component;
	---------------------------------------------------------
	component divider is 
    port (
        divclk: in std_logic;
        enable: in std_logic;
        rst: in std_logic;
        dividend: in std_logic_vector(31 downto 0);
        divisor: in std_logic_vector(31 downto 0);
        quotient: out std_logic_vector(31 downto 0);
        residue: out std_logic_vector(31 downto 0);
        set_divifg: out std_logic
    );
	end component;
	---------------------------------------------------------
	component dividerEnv is
   	 port (
        rst, en, clk : in std_logic;
        MemWrite, MemRead : in std_logic;
        addressbus : in std_logic_vector(11 downto 0);
        databus : inout std_logic_vector(31 downto 0);
        set_divifg : out std_logic
   	 );
	end component;

	component InterruptController is
	generic (AddressBusWidth : integer := 12;
			DataBusWidth : integer := 32;
			IRQSize : integer := 7;
			REGSize : integer := 8);
	port (
		  clk, rst, MemReadBus, MemWriteBus : in std_logic;
		  AddressBus : in std_logic_vector(AddressBusWidth-1 downto 0);
		  DataBus : inout std_logic_vector(DataBusWidth-1 downto 0);
		  IntSRC : in std_logic_vector(IRQSize-1 downto 0); -- IRQ0-IRQ6
		  IRQOut : out std_logic_vector(IRQSize-1 downto 0); -- IRQ0-IRQ6
		  GIE: in std_logic;
		  ClrIRQ: out std_logic_vector(IRQSize-1 downto 0);
		  IntActive: out std_logic;
		  IntReq: out std_logic;
		  IntAck: in std_logic
	);
	end component;
	---------------------------------------------------------
	component comparatorEnv is
	port(
		rst, clk: in std_logic;
		MemWrite, MemRead: in std_logic;
		addressbus: in std_logic_vector(11 downto 0);
		databus: inout std_logic_vector(31 downto 0);
		PWMout: out std_logic;
		set_BTIFG: out std_logic
	);
	end component;
	---------------------------------------------------------
	component comparator is
    	port(
        clk : in std_logic;
        rst : in std_logic;
        en: in std_logic;
        BTCNT : in std_logic_vector(31 downto 0);
        BTCLO : in std_logic_vector(31 downto 0);
        CLKEDBTCNT : out std_logic_vector(31 downto 0)
    		);
	end component;
	---------------------------------------------------------
	component ClockDivider is
	Port (
		clk  : in  std_logic; -- Input clock
		clk_out2 : out std_logic; -- Output clock at half frequency
		clk_out4 : out std_logic; -- Output clock at 1/4 frequency
		clk_out8 : out std_logic  -- Output clock at 1/8 frequency
	);
	end component;
	---------------------------------------------------------
	component TimerOutputUnit is
    		port(
        BTCCR1   : in std_logic_vector(31 downto 0);
        BTOUTEN  : in std_logic;
        BTOUTMD  : in std_logic;
        counter  : in std_logic_vector(31 downto 0);
        PWMout   : out std_logic
    	);
	end component;
	---------------------------------------------------------


end aux_package;
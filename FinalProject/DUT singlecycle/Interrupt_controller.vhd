LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------- System Interrupt Controller with FPGA ---------------
ENTITY InterruptController IS
  GENERIC (AddressBusWidth : integer := 32;
			DataBusWidth : integer := 32;
            IRQSize : integer := 7;
            REGSize : integer := 8); 
  PORT (
		  -- control signals
		  clk, rst, MemReadBus, MemWriteBus : in std_logic;
		  -- Busses
		  AddressBus : in std_logic_vector(AddressBusWidth-1 downto 0);
		  DataBus : inout std_logic_vector(DataBusWidth-1 downto 0);
		  -- Interrupt Source irq0-irq6
		  IntSRC : in std_logic_vector(IRQSize-1 downto 0);
		  -- Interrupt Control
		  ChipSelect: in std_logic;
          ClrIRQ: in std_logic;
          GIE: in std_logic;
          IntActive: out std_logic;
          -- Interrupt Request and Acknowledge
          IntReq: out std_logic;
          IntAck: in std_logic;
  );
END InterruptController;
------------------------------------------------
ARCHITECTURE struct OF InterruptController IS 
	signal IE, IFG : std_logic_vector(IRQSize-1 downto 0);
    signal TypeREG : std_logic_vector(REGSize-1 downto 0);
BEGIN
	-------------------Chip Select Decorder---------------------------
	CS_LED <= '0' when rst = '1' else '1' when AddressBus = X"800" else '0';
	CS_HEX0 <= '0' when rst = '1' else '1' when AddressBus = X"804" else '0';
	CS_HEX1 <= '0' when rst = '1' else '1' when AddressBus = X"805" else '0';
	CS_HEX2 <= '0' when rst = '1' else '1' when AddressBus = X"808" else '0';
	CS_HEX3 <= '0' when rst = '1' else '1' when AddressBus = X"809" else '0';
	CS_HEX4 <= '0' when rst = '1' else '1' when AddressBus = X"80C" else '0';
	CS_HEX5 <= '0' when rst = '1' else '1' when AddressBus = X"80D" else '0';
	CS_SW <= '0' when rst = '1' else '1' when AddressBus = X"810" else '0';
	CS_KEY <= '0' when rst = '1' else '1' when AddressBus = X"814" else '0';

	LEDS: OutputInterface 
	generic map (SevenSegment => false, LEDSize => 10)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_LED,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(9 downto 0),
			IO_Out => LEDs
			);

	HEX0: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX0,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX0
			);

	HEX1: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX1,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX1
			);

	HEX2: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX2,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX2
			);

	HEX3: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX3,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX3
			);

	HEX4: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX4,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX4
			);
	
	HEX5: OutputInterface
	generic map (SevenSegment => true, SEGSize => 7)
	port map (clk => clk,
			rst => rst,
			ChipSelect => CS_HEX5,
			MemRead => MemReadBus,
			MemWrite => MemWriteBus,
			RWData => DataBus(6 downto 0),
			IO_Out => HEX5
			);
	
	SW: InputInterface
	port map (ChipSelect => CS_SW,
			MemRead => MemReadBus,
			RData => DataBus,
			IO_In => SW
			);
	 
END struct;

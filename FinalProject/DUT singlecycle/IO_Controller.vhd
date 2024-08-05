LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------- System IO Controller with FPGA ---------------
-- Hardware Test Case: Digital System (ALU) Interface IO with FPGA board
-- ALU Inputs (Y,X,ALUFN) are outputs of three registers with KEYX enable and Switches[7:0] as register input
-- KEY0, KEY1, KEY2 - Y, ALUFN, X registers enable respectively
-- Switches[7:0] - Input for registers
-- Y connected to HEX3-HEX2
-- X connected to HEX0-HEX1
-- ALUFN connected to LEDR9-LEDR5
-- ALU Outputs goes to Leds and Hex
-------------------------------------
ENTITY IO_Controller IS
  GENERIC (	ControlBusWidth : integer := 8;
			AddressBusWidth : integer := 32;
			DataBusWidth : integer := 32); 
  PORT (
		  -- control signals
		  clk, rst, MemReadBus, MemWriteBus : in std_logic;
		  -- Busses
		  AddressBus : in std_logic_vector(AddressBusWidth-1 downto 0);
		  DataBus : inout std_logic_vector(DataBusWidth-1 downto 0);
		  -- Switch Port
		  SW : in std_logic_vector(9 downto 0);
		  -- Keys Ports
		  KEY0, KEY1, KEY2, KEY3 : in std_logic;
		  -- 7 segment Ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0);
		  -- Leds Port
		  LEDs : out std_logic_vector(9 downto 0)
  );
END IO_Controller;
------------------------------------------------
ARCHITECTURE struct OF IO_Controller IS 
	signal CS_LED, CS_HEX0, CS_HEX1,CS_HEX2,CS_HEX3,CS_HEX4,CS_HEX5, CS_SW, CS_KEY : std_logic;
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

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
		  IntSRC : in std_logic_vector(IRQSize-1 downto 0); -- IRQ0-IRQ6
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
	signal IRQ, IRQ_CLR: std_logic_vector(IRQSize-1 downto 0);

	signal IE, IFG : std_logic_vector(IRQSize-1 downto 0);
    signal TypeREG : std_logic_vector(REGSize-1 downto 0);
BEGIN

	 
END struct;

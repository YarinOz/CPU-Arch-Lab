LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------- System Interrupt Controller with FPGA ---------------
ENTITY InterruptController IS
  GENERIC (AddressBusWidth : integer;
			      DataBusWidth : integer;
            IRQSize : integer;
            REGSize : integer); 
  PORT (
		  -- control signals
		  clk, rst, MemReadBus, MemWriteBus : in std_logic;
		  -- Busses
		  AddressBus : in std_logic_vector(AddressBusWidth-1 downto 0);
		  DataBus : inout std_logic_vector(DataBusWidth-1 downto 0);
		  -- Interrupt Source irq0-irq6
		  IntSRC : in std_logic_vector(IRQSize-1 downto 0); -- IRQ0-IRQ6
      IRQOut : out std_logic_vector(IRQSize-1 downto 0); -- IRQ0-IRQ6
		  -- Interrupt Control
      GIE: in std_logic;
      ClrIRQ: out std_logic_vector(IRQSize-1 downto 0);
      IntActive: out std_logic;
      -- Interrupt Request and Acknowledge
      IntReq: out std_logic;
      IntAck: in std_logic
  );
END InterruptController;
------------------------------------------------
ARCHITECTURE struct OF InterruptController IS 
-- emulated JAL (link $k1 R31<=PC+4, jump ISR address) instruction
-- Interrupt sources Addresses
----------------------------------------------------------------
-- 0x814 KEYS 1-3 LSB nibble
-- 0x818 UCTL
-- 0x819 RXBF
-- 0x81A TXBF
-- 0x81C BTCTL
-- 0x820 BTCNT
-- 0x824 BTCCR0
-- 0x828 BTCCR1
-- 0x82C DIVIDEND
-- 0x830 DIVISOR
-- 0x834 DIVQUO
-- 0x838 DIVRES
-- 0x83C IE
-- 0x83D IFG
-- 0x83E TYPE
----------------------------------------------------------------
	signal IRQ : std_logic_vector(IRQSize-1 downto 0) := (OTHERS => '0');
  signal IRQ_CLR: std_logic_vector(IRQSize-1 downto 0) := (OTHERS => '1');

	signal IE, IFG : std_logic_vector(IRQSize-1 downto 0);
  signal TypeREG : std_logic_vector(REGSize-1 downto 0);

BEGIN


-- MCU Output
-- Read to DataBus IE, IFG, TypeReg
DataBus <= X"000000" & TypeReg 	WHEN ((AddressBus = X"83E" AND MemReadBus = '1') OR (IntAck = '0' AND MemReadBus = '0')) ELSE
			X"000000"&"0" 	& IE 	WHEN (AddressBus = X"83C" AND MemReadBus = '1') ELSE
			X"000000"&"0" 	& IFG		WHEN (AddressBus = X"83D" AND MemReadBus = '1') ELSE
			(OTHERS => 'Z');

-- MCU Input
process(clk)
begin -- Interrupt Enable Register (sw $t0, 0x83C)
  if falling_edge(clk) then 
    if AddressBus = X"83C" and MemWriteBus = '1' then
      IE <= DataBus(IRQSize-1 downto 0);
    end if;
  end if;
end process;

IFG		<=	DataBus(IRQSize-1 DOWNTO 0)	WHEN (AddressBus = X"83D" AND MemWriteBus = '1') ELSE
			IRQ AND IE;		
TypeReg	<=	DataBus(REGSize-1 DOWNTO 0)	WHEN (AddressBus = X"83E" AND MemWriteBus = '1') ELSE
			(OTHERS => 'Z');

-- Interrupt Request
process (clk, IFG) 
begin 
if (rising_edge(clk)) then
  if (IFG(2)='1' or IFG(3)='1' or IFG(4)='1' or IFG(5)='1' or IFG(6)='1') then
    IntReq <= GIE;
  else 
    IntReq <= '0';
  end if;
end if;
end process;    

-- Interrupt Acknowledge
-- Basic Timer---------------------------
process (clk,rst,IRQ_CLR(2),IntSRC(2))
begin 
    if falling_edge(clk) then
      if (rst = '1') then
        IRQ(2) <= '0';
      elsif (IRQ_CLR(2)='0') then
        IRQ(2) <= '0';
      elsif IntSRC(2)='1' then
        IRQ(2) <= '1';
      end if;
  end if;
end process;
-- KEY1-----------------------------------
process (clk,rst,IRQ_CLR(3),IntSRC(3))
begin 
  if rising_edge(clk) then
    if (rst = '1') then
      IRQ(3) <= '0';
    elsif (IRQ_CLR(3)='0') then
      IRQ(3) <= '0';
    elsif IntSRC(3)='1' then
      IRQ(3) <= '1';
    else
      IRQ(3) <= IRQ(3); -- Hold
    end if;
  end if;
end process;
-- KEY2-----------------------------------
process (clk,rst,IRQ_CLR(4),IntSRC(4))
begin 
  if rising_edge(clk) then
    if (rst = '1') then
      IRQ(4) <= '0';
    elsif (IRQ_CLR(4)='0') then
      IRQ(4) <= '0';
    elsif IntSRC(4)='1' then
      IRQ(4) <= '1';
    else
      IRQ(4) <= IRQ(4); -- Hold
    end if;
  end if;
end process;
-- KEY3-----------------------------------
process (clk,rst,IRQ_CLR(5),IntSRC(5))
begin 
  if rising_edge(clk) then
    if (rst = '1') then
      IRQ(5) <= '0';
    elsif (IRQ_CLR(5)='0') then
       IRQ(5) <= '0';
    elsif IntSRC(5)='1' then
      IRQ(5) <= '1';
    else
      IRQ(5) <= IRQ(5); -- Hold
    end if;
  end if;
end process;
--DIVIDER-----------------------------------
process (clk,rst,IRQ_CLR(6),IntSRC(6))
begin 
  if falling_edge(clk) then
    if (rst = '1') then
      IRQ(6) <= '0';
    elsif (IRQ_CLR(6)='0') then
      IRQ(6) <= '0';
    elsif IntSRC(6)='1' then
      IRQ(6) <= '1';
    end if;
  end if;
end process;
	 

-- Clear IRQ When Interrupt Ack received
-- IRQ_CLR(0) <= '0' WHEN (TypeReg = X"08" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
-- IRQ_CLR(1) <= '0' WHEN (TypeReg = X"0C" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
IRQ_CLR(2) <= '0' WHEN (TypeReg = X"10" AND IntAck = '1') ELSE '1';
IRQ_CLR(3) <= '0' WHEN (TypeReg = X"14" AND IntAck = '1') ELSE '1';
IRQ_CLR(4) <= '0' WHEN (TypeReg = X"18" AND IntAck = '1') ELSE '1';
IRQ_CLR(5) <= '0' WHEN (TypeReg = X"1C" AND IntAck = '1') ELSE '1';
IRQ_CLR(6) <= '0' WHEN (TypeReg = X"20" AND IntAck = '1') ELSE '1';
-- CLR_IRQ_STATUS <= '0' WHEN (TypeReg = X"04" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';

IRQOut <= IRQ;
IntActive <= '1' WHEN (IFG(2)='1' OR IFG(3)='1' OR IFG(4)='1' OR IFG(5)='1' OR IFG(6)='1') ELSE '0';
ClrIRQ <= IRQ_CLR;


-- Interrupt Vectors
TypeReg	<= 	X"00" WHEN rst  = '1' ELSE -- main
            -- X"04" WHEN (IRQ_STATUS = '1' AND IntrEn(0) = '1') ELSE  -- Uart Status Error
            -- X"08" WHEN IFG(0) = '1' ELSE  	-- Uart RX
            -- X"0C" WHEN IFG(1) = '1' ELSE  	-- Uart TX
            X"10" WHEN IFG(2) = '1' ELSE  -- Basic timer
            X"14" WHEN IFG(3) = '1' ELSE  -- KEY1
            X"18" WHEN IFG(4) = '1' ELSE	-- KEY2
            X"1C" WHEN IFG(5) = '1' ELSE	-- KEY3
            X"20" WHEN IFG(6) = '1' ELSE	-- DIV
            (OTHERS => 'Z');

END struct;

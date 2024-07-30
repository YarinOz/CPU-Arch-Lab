library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
 
entity CounterEnvelope is port (
	Clk,En : in std_logic;	
	Qout          : out std_logic); 
end CounterEnvelope;

architecture rtl of CounterEnvelope is
    component counter port(
	      clk,enable : in std_logic;	
	      q          : out std_logic);
    end component;
	 
	component PLL port(
          rst		: IN STD_LOGIC  := '0';
          refclk		: IN STD_LOGIC  := '0';
           outclk_0		: OUT STD_LOGIC ;
		    locked		: OUT STD_LOGIC );
    end component;
	 
    signal PLLOut : std_logic ;
begin
     m0: counter port map(PLLOut,En,Qout);  -- 31.25 KHz
	  m1: PLL port map(
         refclk => Clk,  -- 50 MHz
         outclk_0 => PLLOut -- 2 MHz
	   );
end rtl;



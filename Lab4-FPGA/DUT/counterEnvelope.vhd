library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
 
entity CounterEnvelope is port (
	Clk,En : in std_logic;	
	Qout          : out std_logic_vector (7 downto 0)); 
end CounterEnvelope;

architecture rtl of CounterEnvelope is
    component counter port(
	      clk,enable : in std_logic;	
	      q          : out std_logic_vector (7 downto 0));
    end component;
	 
	component PLL port(
	      areset		: IN STD_LOGIC  := '0';
		   inclk0		: IN STD_LOGIC  := '0';
		       c0		: OUT STD_LOGIC ;
		    locked		: OUT STD_LOGIC );
    end component;
	 
    signal PLLOut : std_logic ;
begin
     m0: counter port map(PLLOut,En,Qout);
	  m1: PLL port map(
	     inclk0 => Clk,
		  c0 => PLLOut
	   );
end rtl;



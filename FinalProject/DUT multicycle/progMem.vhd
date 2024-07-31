library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity ProgMem is
generic( Dwidth: integer:=32;
		 Awidth: integer:=32;
		 dept:   integer:=64);
port(  RmemAddr:	in std_logic_vector(Dwidth-1 downto 0);
	   RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end ProgMem;
--------------------------------------------------------------
architecture behav of ProgMem is

type RAM is array (0 to dept-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRAM: RAM;

begin			   
	
  RmemData <= sysRAM(conv_integer(RmemAddr));

end behav;

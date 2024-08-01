library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity ProgMem is
generic( Dwidth: integer:=32;
		 Awidth: integer:=5;
		 dept:   integer:=64);
port(  clk : in std_logic;
	   -- Read program memory
	   RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
	   RmemData: 	out std_logic_vector(Dwidth-1 downto 0);
	   -- Write program memory
	   WmemEn:   in std_logic;
	   WmemAddr: in std_logic_vector(Awidth-1 downto 0);
	   WmemData: in std_logic_vector(Dwidth-1 downto 0)
);
end ProgMem;
--------------------------------------------------------------
architecture behav of ProgMem is

type RAM is array (0 to dept-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRAM: RAM;

begin			   
process(clk)
	begin
	if (clk'event and clk='1') then
		if (WmemEn='1') then
			-- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
			-- from std_logic_vector to integer
			sysRAM(conv_integer(WmemAddr)) <= WmemData; 
		end if;
	end if;
	end process;
    RmemData <= sysRAM(conv_integer(RmemAddr));

end behav;

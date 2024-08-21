library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity RF is
generic( Dwidth: integer:=32;
		 Awidth: integer:=5);
port(	clk,rst,WregEn: in std_logic;	
		WregData:	in std_logic_vector(Dwidth-1 downto 0);
		WregAddr, RregAddr1, RregAddr2: in std_logic_vector(Awidth-1 downto 0);
		RregData1, RregData2: out std_logic_vector(Dwidth-1 downto 0);
		GIE: out std_logic
);
end RF;
--------------------------------------------------------------
architecture behav of RF is

type RegFile is array (0 to 2**Awidth-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRF: RegFile;

begin			   
  process(clk,rst)
  begin
	if (rst='1') then
		sysRF(0) <= (others=>'0');   -- R[0] is constant Zero value 
	elsif (clk'event and clk='1') then
	    if (WregEn='1') then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRF(conv_integer(WregAddr)) <= WregData; 
	    end if;
	end if;
  end process;
	
  RregData1 <= sysRF(conv_integer(RregAddr1));
  RregData2 <= sysRF(conv_integer(RregAddr2));
  GIE <= sysRF(26)(0);

end behav;

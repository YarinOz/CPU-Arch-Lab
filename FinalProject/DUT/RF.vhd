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
		GIE: out std_logic;
		INTR: in std_logic;
		ISR2PC: in std_logic
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
		sysRF(26) <= (others=>'0');  -- GIE is set to 0
	elsif (clk'event and clk='0') then
	    if (WregEn='1' and WregAddr /= "11111") then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRF(conv_integer(WregAddr)) <= WregData;
		end if;
	elsif (clk'event and clk='1') then
		if (WregEn='1' and WregAddr="11111") then -- jal
			sysRF(31) <= WregData; -- $ra(31) <= PC+4
		elsif (ISR2PC='1') then  -- interrupt return
			sysRF(27) <= WregData; -- $ra(27) <= PC+4
		end if;
		if (INTR='1') then -- interrupt, GIE is set to 0
			sysRF(26)(0) <= '0';
	    end if;
	end if;
  end process;
	
  RregData1 <= sysRF(conv_integer(RregAddr1));
  RregData2 <= sysRF(conv_integer(RregAddr2));
  GIE <= sysRF(26)(0);

end behav;

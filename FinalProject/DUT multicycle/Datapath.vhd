library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity Datapath is
generic(
    Dwidth: integer := 16;
    Awidth: integer := 6;
    Regwidth: integer := 4;
    dept: integer := 64
);
port(
    TBactive, clk, rst: in std_logic;
    -- control signals
    Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in :in std_logic;
    PCsel, Rfaddr: in std_logic_vector(1 downto 0);
    OPC: in std_logic_vector(3 downto 0);
    -- status signals
    st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, jn, un4: out std_logic;
    -- test bench signals
    -- program memory signals
    progMemEn: in std_logic;
    progDataIn: in std_logic_vector(Dwidth-1 downto 0);
    progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
    -- -- data memory signals
    dataMemEn: in std_logic;
    dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
    dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
    dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PCout : std_logic_vector(Awidth-1 downto 0):="000000";
    -- IR register
    signal IR: std_logic_vector(Dwidth-1 downto 0);

    -- RF signals
    signal RWAddr: std_logic_vector(Regwidth-1 downto 0);           -- RF write address
    signal RFRData, RFWData: std_logic_vector(Dwidth-1 downto 0); -- RF read and write data

    -- ALU signals  
    signal REGA, REGC, Bin, C: std_logic_vector(Dwidth-1 downto 0);

    -- Bi directional bus
    signal fabric, offset_addr: std_logic_vector(Dwidth-1 downto 0);

    -- Memory signals
    signal progDataOut: std_logic_vector(Dwidth-1 downto 0);

    -- Datamem signals
    signal DataIn, DataOut: std_logic_vector(Dwidth-1 downto 0);
    signal WAddr, RAddr, RMUX, WMUX: std_logic_vector(Awidth-1 downto 0);
    signal EnData: std_logic;

    -- temp signals
    signal temp1, temp2: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
U1: progMem generic map (Dwidth, Awidth, dept) port map (clk, progMemEn, progDataIn, progWriteAddr, PCout, progDataOut);
U2: dataMem generic map (Dwidth, Awidth, dept) port map (clk, EnData, DataIn, WMUX, RMUX, DataOut);
U3: RF generic map (Dwidth,Regwidth) port map (clk, rst, RFin, RFWData, RWAddr, RWAddr, RFRData);
U4: ALU generic map (Dwidth) port map (Bin,REGA, OPC, C, Nflag, Cflag, Zflag); -- B-A, B+A
-----------------------------------------------------------------------------------------------

------------------- Bi-directional bus ---------------------------------------------------------
-- DatamemOut: BidirPin generic map (Dwidth) port map (datadataOut, Mem_out, datareadAddr, fabric);
ALUout: BidirPin generic map (Dwidth) port map (REGC, Cout, Bin, fabric);
RegFout: BidirPin generic map (Dwidth) port map (RFRData, RFout, RFWData, fabric);
DataMemOut: BidirPin generic map (Dwidth) port map (DataOut, Mem_out, temp1, fabric);
IMM1out: BidirPin generic map (Dwidth) port map (offset_addr, Imm1_in, temp1, fabric);
IMM2out: BidirPin generic map (Dwidth) port map (offset_addr, Imm2_in, temp2, fabric);

offset_addr <= SXT(IR(3 downto 0), Dwidth) when Imm2_in = '1' else -- ld/st
               SXT(IR(7 downto 0), Dwidth); -- jmp/jc/jnc/mov
-----------------------------------------------------------------------------------------------
    -- Program counter process
    process(clk, rst)
    -- offset address in J-Type instructions
    begin  -- need to add controls: jump, branch, bcond
        if rst = '1' then
            PCout <= (others => '0');
        elsif rising_edge(clk) then
            if jump = '1' then
                PCout <= offset_addr(7 downto 0);
            elsif (bcond = '1' and branch = '1') then
                PCout <= (PCout + 4 + offset_addr(7 downto 0));
            else
                PCout <= PCout + 4;
            end if;
        end if;
    end process;

    -- ALU process 
    process(clk)
    begin
        if rising_edge(clk) then
            if Ain = '1' then
                REGA <= fabric;
            end if;
            if Cin = '1' then
                REGC <= C;
            end if;
        end if;
    end process;

    -- Data Memory Write 
    DataMem_Write: process(clk, rst) 
    begin
    if rst = '1' then
        WAddr <= (others => '0');
	elsif rising_edge(clk) then
		if (Mem_in = '1') then
			WAddr <= fabric(Awidth-1 downto 0);
            -- report "fabric = " & to_string(fabric)
			-- & LF & "time =       " & to_string(now) ;
		end if;
	end if;
			
    end process;
    RAddr <= fabric(Awidth-1 downto 0);
    -- TB connectivity
    EnData <= dataMemEn	when TBactive = '1' else Mem_wr;
    DataIn <= dataDataIn	when TBactive = '1' else fabric;
    WMUX <= dataWriteAddr when TBactive = '1' 	else WAddr;
    RMUX <= dataReadAddr when TBactive = '1' 	else RAddr;
    dataDataOut <= DataOut;
    
end behav;

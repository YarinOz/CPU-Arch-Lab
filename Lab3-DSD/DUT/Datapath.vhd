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
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: out std_logic;
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
    -- signal PCout, CurrPC, NextPC: std_logic_vector(Awidth-1 downto 0);
    signal CurrPC, NextPC: std_logic_vector(7 downto 0):=(others =>'0'); -- temporary
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
IMM1out: BidirPin generic map (Dwidth) port map (offset_addr, Imm1_in, RFWData, fabric);
IMM2out: BidirPin generic map (Dwidth) port map (offset_addr, Imm2_in, RFWData, fabric);

offset_addr <= SXT(IR(3 downto 0), Dwidth) when Imm2_in = '1' else -- ld/st
               SXT(IR(7 downto 0), Dwidth); -- jmp/jc/jnc/mov
-----------------------------------------------------------------------------------------------
    -- Program counter process
    process(clk, PCin, PCsel)
    -- offset address in J-Type instructions
    begin
        if rising_edge(clk) then
            if PCin = '1' then
                CurrPC <= NextPC;
                -- report "NextPC = " & to_string(NextPC);
            end if;
        end if;
        case PCsel is
            when "00" =>
                NextPC <= (CurrPC + 1);
            when "01" =>
                NextPC <= (CurrPC + 1 + offset_addr(7 downto 0));
            when "10" =>
                NextPC <= (others => '0');
            when others =>
                NextPC <= NextPC;  -- Unaffected
        end case;
        PCout <= CurrPC(Awidth-1 downto 0);
    end process;

    -- IR register process
    process(clk , IRin, progDataOut, RFaddr, IR)
    variable ra, rb, rc: std_logic_vector(Regwidth-1 downto 0);
    begin
        ra := IR(11 downto 8);
        rb := IR(7 downto 4);
        rc := IR(3 downto 0);
        if rising_edge(clk) then
            if IRin = '1' then
                IR <= progDataOut;
            end if;
        end if;
        -- R/W ra.rb.rc to RF process
        case RFaddr is
            when "00" => 
                RWAddr <= rc;
            when "01" => 
                RWAddr <= rb;
            when "10" => 
                RWAddr <= ra;
            when others => 
                RWAddr <= RWAddr;  -- Unaffected
        end case;
    end process;

    -- OPC decoder 
    OPC_DECODER: process(IR)
    variable opcode: std_logic_vector(3 downto 0);
    begin
        opcode := IR(Dwidth-1 downto Dwidth-4);
        -- report "IR = " & to_string(IR);
        -- report "opcode = " & to_string(opcode);
        add <= '1' when opcode = "0000" else '0';
        sub <= '1' when opcode = "0001" else '0';
        andf <= '1' when opcode = "0010" else '0';
        orf <= '1' when opcode = "0011" else '0';
        xorf <= '1' when opcode = "0100" else '0';
        un1 <= '1' when opcode = "0101" else '0';
        un2 <= '1' when opcode = "0110" else '0';
        jmp <= '1' when opcode = "0111" else '0';
        jc <= '1' when opcode = "1000" else '0';
        jnc <= '1' when opcode = "1001" else '0';
        un3 <= '1' when opcode = "1010" else '0';
        un4 <= '1' when opcode = "1011" else '0';
        mov <= '1' when opcode = "1100" else '0';
        ld <= '1' when opcode = "1101" else '0';
        st <= '1' when opcode = "1110" else '0';
        done <= '1' when opcode = "1111" else '0';
    end process OPC_DECODER;

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
    DataMem_Write: process(clk) 
    begin
	if rising_edge(clk) then
		if (Mem_in = '1') then
			WAddr <= fabric(Awidth-1 downto 0);
            -- report "fabric = " & to_string(fabric)
			-- & LF & "time =       " & to_string(now) ;
		end if;
	end if;
			
    end process;
    -- TB connectivity
    EnData <= dataMemEn	when TBactive = '1' else Mem_wr;
    DataIn <= dataDataIn	when TBactive = '1' else fabric;
    WMUX <= dataWriteAddr when TBactive = '1' 	else WAddr;
    RMUX <= dataReadAddr when TBactive = '1' 	else RAddr;
    dataDataOut <= DataOut;
    
end behav;

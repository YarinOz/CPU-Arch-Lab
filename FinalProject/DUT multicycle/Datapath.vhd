library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity Datapath is
generic(
    Dwidth: integer := 32;
    Awidth: integer := 32;
    Regwidth: integer := 4;
    dept: integer := 64
);
port(
    clk, rst: in std_logic;
    -- control signals
    RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
    ALUop: in std_logic_vector(5 downto 0)
    -- status signals
    opcode, funct: out std_logic_vector(5 downto 0);
    -- test bench signals
    -- program memory signals
    -- progMemEn: in std_logic;
    -- progDataIn: in std_logic_vector(Dwidth-1 downto 0);
    -- progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
    -- -- -- data memory signals
    -- dataMemEn: in std_logic;
    -- dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
    -- dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
    -- dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PCout : std_logic_vector(Awidth-1 downto 0):="000000";

    -- RF signals
    signal RWAddr: std_logic_vector(Regwidth-1 downto 0);           -- RF write address
    signal RFRData, RFWData: std_logic_vector(Dwidth-1 downto 0); -- RF read and write data

    -- Memory signals
    signal progDataOut: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
U1: progMem generic map (Dwidth, Awidth, dept) port map (PCout, instruction);
U2: dataMem generic map (Dwidth, Awidth, dept) port map (clk, MemWrite, RFData2, ALUout, DataOut);
U3: RF generic map (Dwidth,Regwidth) port map (clk, rst, RegWrite, RFWDataMUX, RFMUX, rs, rt, RFData1, RFData2);
U4: ALU generic map (Dwidth) port map (RFData1, ALUMUX, ALUop, ALUout, Nflag, Cflag, Zflag); -- B-A, B+A
-----------------------------------------------------------------------------------------------
-- Instruction signals
opcode <= instruction(31 downto 26);
rs <= instruction(25 downto 21);
rt <= instruction(20 downto 16);
rd <= instruction(15 downto 11);
shamt <= instruction(10 downto 6);
funct <= instruction(5 downto 0);
imm <= SXT(instruction(15 downto 0), Dwidth);
address <= SXT(instruction(25 downto 0), Dwidth);

-- Branch condition
bcond <= (rs = rt) when opcode = "000100" else -- beq
         (rs /= rt) when opcode = "000101" else -- bne
         '0';
-- RF connectivity
RFMUX <= rt when (RegDst = '0') else rd;
RFWDataMUX <= ALUout when MemtoReg = '0' else DataOut;

-- ALU connectivity
ALUMUX <= RFData2 when ALUsrc = '0' else imm;
-----------------------------------------------------------------------------------------------
    -- Program counter process
    process(clk, rst)
    -- offset address in J-Type instructions
    begin  
        if rst = '1' then
            PCout <= (others => '0');
        elsif rising_edge(clk) then
            if jump = '1' then
                PCout <= address; -- if jr then address <= ra
            elsif (bcond = '1' and branch = '1') then
                PCout <= (PCout + 4 + imm);
            else
                PCout <= PCout + 4;
            end if;
        end if;
    end process;
    
end behav;

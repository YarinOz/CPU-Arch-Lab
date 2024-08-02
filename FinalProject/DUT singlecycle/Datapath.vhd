library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity Datapath is
generic(
    Dwidth: integer := 32;
    Awidth: integer := 5;
    Regwidth: integer := 4;
    dept: integer := 64
);
port(
    clk, rst, init: in std_logic;
    -- control signals
    RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
    ALUop: in std_logic_vector(5 downto 0);
    -- status signals
    opcode, funct: out std_logic_vector(5 downto 0);
    -- test bench signals
    -- for initial program memory
    -- program memory signals
    progMemEn: in std_logic;
    progDataIn: in std_logic_vector(Dwidth-1 downto 0);
    progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
    -- data memory init, en=MemWrite, datawrite=RamWrite, dataWriteAddr=dataWriteAddr readaddress=ALUmemWrite, dataout=DataOut
    -- -- -- data memory signals
    dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
    dataWriteAddr: in std_logic_vector(Awidth-1 downto 0)
);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PCout : std_logic_vector(Dwidth-1 downto 0):=(others => '0');
    signal PCprogAddress: std_logic_vector(Awidth-1 downto 0);

    -- Memory signals
    signal progDataOut: std_logic_vector(Dwidth-1 downto 0);
    signal RamWrite: std_logic_vector(Dwidth-1 downto 0);

    -- Instruction signals
    signal instruction: std_logic_vector(Dwidth-1 downto 0);
    signal imm : std_logic_vector(Dwidth-1 downto 0);
    signal address : std_logic_vector(27 downto 0);
    signal rs, rt, rd: std_logic_vector(Awidth-1 downto 0);
    signal shamt: std_logic_vector(4 downto 0);
    signal bcond,zero: std_logic;
    signal ALUMUX: std_logic_vector(Dwidth-1 downto 0);
    signal RFMUX: std_logic_vector(Awidth-1 downto 0);
    signal RFWDataMUX: std_logic_vector(Dwidth-1 downto 0);
    signal RFData1, RFData2: std_logic_vector(Dwidth-1 downto 0);
    signal ALUout: std_logic_vector(Dwidth-1 downto 0);
    -- ALU to memory address
    signal ALUmemWrite: std_logic_vector(Awidth-1 downto 0);
    signal DataOut: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
flash: progMem generic map (Dwidth, Awidth, dept) port map (clk, PCprogAddress, instruction, progMemEn, progWriteAddr, progDataIn);
ram: dataMem generic map (Dwidth, Awidth, dept) port map (clk, MemWrite, RamWrite, dataWriteAddr, ALUmemWrite, DataOut);
registerfile: RF generic map (Dwidth,Awidth) port map (clk, rst, RegWrite, RFWDataMUX, RFMUX, rs, rt, RFData1, RFData2);
ALUnit: ALU generic map (Dwidth) port map (RFData1, ALUMUX, ALUop, ALUout); -- B-A, B+A
-----------------------------------------------------------------------------------------------
-- Instruction signals
opcode <= instruction(31 downto 26);
rs <= instruction(25 downto 21);
rt <= instruction(20 downto 16);
rd <= instruction(15 downto 11);
shamt <= instruction(10 downto 6);
funct <= instruction(5 downto 0);
-- Immediate and address signals (sign extension and shift left 2 for address alignment) 
imm <= SXT(instruction(15 downto 0), Dwidth);
-- 28 bits address after shifting left 2
address <= instruction(25 downto 0) & "00";

-- Program counter address to program memory
PCprogAddress <= PCout(Awidth-1 downto 0);

-- ALU to memory address
ALUmemWrite <= ALUout(Awidth-1 downto 0);

-- Memory initialization
RamWrite <= dataDataIn when init='1' else RFData2;

-- Branch condition
process(opcode, rs, rt)
begin
    if ((opcode = "000100" and rs = rt) or (opcode = "000101" and rs /= rt)) then
        bcond <= '1';
    else
        bcond <= '0';
    end if;
end process;    

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
                PCout <= PCout(Dwidth-1 downto 28) & address; -- if jr then address <= ra
            elsif (bcond = '1' and branch = '1') then
                PCout <= PCout + 4 + imm;
            else
                PCout <= PCout + 4;
            end if;
        end if;
    end process;
    
end behav;

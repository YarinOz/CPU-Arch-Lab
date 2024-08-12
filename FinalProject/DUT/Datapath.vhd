library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

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
    PCSrc: in std_logic_vector(1 downto 0);
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
    dataMemEn: in std_logic;
    dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
    dataWriteAddr: in std_logic_vector(Awidth-1 downto 0);
    dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PCout : std_logic_vector(Dwidth-1 downto 0):=(others => '0');
    signal PCprogAddress: std_logic_vector(Awidth-1 downto 0);

    -- Memory signals
    signal RamWrite: std_logic_vector(Dwidth-1 downto 0);
    signal WMUX: std_logic_vector(Awidth-1 downto 0);
    signal RamEN: std_logic;

    -- Instruction signals
    signal instruction: std_logic_vector(Dwidth-1 downto 0);
    signal imm : std_logic_vector(Dwidth-1 downto 0);
    signal address : std_logic_vector(27 downto 0);
    signal rs, rt, rd: std_logic_vector(Awidth-1 downto 0);
    signal shamt: std_logic_vector(4 downto 0);
    signal bcond: std_logic;
    signal ALUMUX: std_logic_vector(Dwidth-1 downto 0);
    signal ALUOPT: std_logic_vector(Dwidth-1 downto 0);
    signal RFMUX: std_logic_vector(Awidth-1 downto 0);
    signal RFWDataMUX: std_logic_vector(Dwidth-1 downto 0);
    signal RFData1, RFData2: std_logic_vector(Dwidth-1 downto 0);
    signal ALUout: std_logic_vector(Dwidth-1 downto 0);
    -- ALU to memory address
    signal ALUmemWrite: std_logic_vector(Awidth-1 downto 0);
    signal DataOut: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
flash: progMem generic map (Dwidth, Awidth, dept) port map (clk, init, PCprogAddress, instruction, progMemEn, progWriteAddr, progDataIn);
ram: dataMem generic map (Dwidth, Awidth, dept) port map (clk, RamEN, RamWrite, WMUX, WMUX, DataOut);
registerfile: RF generic map (Dwidth,Awidth) port map (clk, rst, RegWrite, RFWDataMUX, RFMUX, rs, rt, RFData1, RFData2);
ALUnit: ALU generic map (Dwidth) port map (ALUOPT, ALUMUX, ALUop, ALUout); -- B-A, B+A
-----------------------------------------------------------------------------------------------
-------------------- Data/Program Memory -------------------------------------------------------
ProgMen: altsyncram
generic map (
    operation_mode => "ROM",
    width_A => Dwidth,
    widthad_A => Awidth,
    lpm_type => "altsyncram",
    outdata_reg_a => "UNREGISTERED",
    init_file => "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/DUT/program/ITCM.hex",
    intended_device_family => "Cyclone"
)
port map (
    clock0 => clk,
    address_a => PCprogAddress,
    q_a => instruction
);

DataMem: altsyncram
generic map (
    operation_mode => "SINGLE_PORT",
    width_A => Dwidth,
    widthad_A => Awidth,
    lpm_type => "altsyncram",
    outdata_reg_a => "UNREGISTERED",
    init_file => "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/DUT/program/DTCM.hex"
    intended_device_family => "Cyclone"
)
port map (
    clock0 => clk,
    address_a => WMUX,
    data_a => RamWrite,
    wren_a => RamEN,
    q_a => DataOut
);
-----------------------------------------------------------------------------------------------
-- Instruction signals
opcode <= instruction(31 downto 26) when init='0' else (others => '1');
rs <= instruction(25 downto 21);
rt <= instruction(20 downto 16);
rd <= instruction(15 downto 11);
shamt <= instruction(10 downto 6);
funct <= instruction(5 downto 0) when init='0' else (others => '1');
-- Immediate and address signals (sign extension and shift left 2 for address alignment) 
imm <= SXT(instruction(15 downto 0), Dwidth);
-- 28 bits address after shifting left 2
address <= "00" & instruction(25 downto 0);

-- Program counter address to program memory
PCprogAddress <= PCout(Awidth-1 downto 0) when init='0' else (others => 'Z');

-- ALU to memory address
ALUmemWrite <= ALUout(Awidth-1 downto 0);

-- Memory initialization
RamWrite <= dataDataIn when init='1' else RFData2;
WMUX <= dataWriteAddr when init='1' else ALUmemWrite;
RamEN <= dataMemEn when init='1' else MemWrite;

dataDataOut <= DataOut;

-- Branch condition
process(opcode, rs, rt)
begin
    if ((opcode = "000100" and rs = rt) or (opcode = "000101" and rs /= rt)) then
        bcond <= '1';
    else
        bcond <= '0';
    end if;
end process;    

-- RF connectivity (for jal, r31 <= PCout + 1)
RFMUX <= rt when (RegDst = '0') else X"1F" when (PCSrc="10") else rd;
RFWDataMUX <= ALUout when MemtoReg = '0' else (PCout + 1) when (PCSrc="10") else DataOut;

-- ALU connectivity
-- rs or shamt for shift operations
ALUOPT <= ("000000000000000000000000000" & shamt) when (opcode="000000" and (funct = "000000" or funct = "000010")) else RFData1;
ALUMUX <= RFData2 when ALUsrc = '0' else imm;
-----------------------------------------------------------------------------------------------
    -- Program counter process
    process(clk, rst)
    -- offset address in J-Type instructions
    begin  
        if rst = '1' then
            PCout <= (others => '0');
        elsif (rising_edge(clk) and init='0') then
            if jump = '1' then
                case PCSrc is
                    when "01" =>
                        PCout <= PCout(Dwidth-1 downto 28) & address; -- j
                    when "10" =>
                        -- r31 <= PCout + 1;
                        PCout <= PCout(Dwidth-1 downto 28) & address; -- jal
                    when "11" => -- jr
                        PCout <= RFData1;
                    when others =>
                        PCout <= PCout + 1;
                end case;
            elsif (bcond = '1' and branch = '1') then
                PCout <= PCout + 1 + imm;
            else
                PCout <= PCout + 1;  -- "PC+4"
            end if;
        elsif init='1' then
            PCout <= PCout; -- Unaffected
        end if;
    end process;
    
end behav;

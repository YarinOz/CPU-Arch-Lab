library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity Datapath is
generic(
    Dwidth: integer;
    Awidth: integer;
    Regwidth: integer;
    sim: boolean
);
port(
    clk, rst, ena: in std_logic;
    -- control signals
    RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: in std_logic;
    ALUop: in std_logic_vector(5 downto 0);
    PCSrc: in std_logic_vector(1 downto 0);
    -- status signals
    opcode, funct: out std_logic_vector(5 downto 0);
    -- MEM/IO signals
    -- Busses
    AddrBus: out std_logic_vector(Awidth-1 downto 0);
    DataBus: inout std_logic_vector(Dwidth-1 downto 0);
    ControlBus: out std_logic_vector(15 downto 0)

);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PC, PCplus4: std_logic_vector(Dwidth-1 downto 0);

    -- Memory signals
    signal RamWrite: std_logic_vector(Dwidth-1 downto 0);
    signal RamEN: std_logic;
    signal DmemAddr, ImemAddr: std_logic_vector(Awidth-1 downto 0);

    -- Instruction signals
    signal instruction: std_logic_vector(Dwidth-1 downto 0);
    signal imm, address, immPC: std_logic_vector(Dwidth-1 downto 0);
    signal rs, rt, rd, LUIMUX: std_logic_vector(4 downto 0);
    signal shamt: std_logic_vector(4 downto 0);
    signal bcond: std_logic;
    signal ALUMUX, ALUOPT: std_logic_vector(Dwidth-1 downto 0);
    signal RFMUX: std_logic_vector(4 downto 0);
    signal RFWDataMUX: std_logic_vector(Dwidth-1 downto 0);
    signal RFData1, RFData2: std_logic_vector(Dwidth-1 downto 0);
    signal ALUout: std_logic_vector(Dwidth-1 downto 0);
    -- ALU to memory address
    signal DataOut: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
registerfile: RF generic map (Dwidth,5) port map (clk, rst, RegWrite, RFWDataMUX, RFMUX, LUIMUX, rt, RFData1, RFData2);
ALUnit: ALU generic map (Dwidth) port map (ALUOPT, ALUMUX, ALUop, ALUout); -- B-A, B+A
-------------------- Data/Program Memory -------------------------------------------------------
ProgMen: altsyncram
generic map (
    operation_mode => "ROM",
    width_A => Dwidth,
    widthad_A => Awidth,
    lpm_type => "altsyncram",
    outdata_reg_a => "UNREGISTERED",
    init_file => "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/ITCM.hex",
    intended_device_family => "Cyclone"
)
port map (
    clock0 => clk,
    address_a => ImemAddr,
    q_a => instruction
);

DataMem: altsyncram
generic map (
    operation_mode => "SINGLE_PORT",
    width_A => Dwidth,
    widthad_A => Awidth,
    lpm_type => "altsyncram",
    outdata_reg_a => "UNREGISTERED",
    init_file => "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/FinalProject/program/DTCM.hex",
    intended_device_family => "Cyclone"
)
port map (
    clock0 => not clk,
    address_a => DmemAddr,
    data_a => RamWrite,
    wren_a => RamEN,
    q_a => DataOut
);
--------------------- Simulataion and FPGA -----------------------------------------------------
-- Memory address
ModelSim:
if sim = true generate
    ImemAddr <= "00" & PC(Awidth-1 downto 2);
    DmemAddr <= "00" & ALUout(Awidth-1 downto 2);
end generate;
FPGA:
if sim = false generate
    DmemAddr <= PC(Awidth-1 downto 0);
    DmemAddr <= ALUout(Awidth-1 downto 0);
end generate;
-----------------------------------------------------------------------------------------------
-- Instruction signals
opcode <= instruction(31 downto 26) when ena='1' else (others => '1');
rs <= instruction(25 downto 21);
rt <= instruction(20 downto 16);
rd <= instruction(15 downto 11);
shamt <= instruction(10 downto 6);
funct <= instruction(5 downto 0) when ena='1' else (others => '1');
-- Immediate and address signals (sign extension)(if lui imm = imm << 16) 
imm <= SXT(instruction(15 downto 0), Dwidth);
-- Immediate for branch and jump instructions
immPC <= imm(Dwidth-3 downto 0) & "00";
-- 28 bits address after shifting left 2
address <= PCplus4(31 downto 28) & instruction(25 downto 0) & "00";
-- RF change RFDATA1 for LUI (imm(31:16)&rt(15:0)->rt)
LUIMUX <= rt when opcode="001111" else rs;

-- Memory enaialization
RamWrite <= RFData2;
RamEN <= MemWrite and ena;
-- Busses
AddrBus <= DmemAddr;
DataBus <= RamWrite;

-- Branch condition
process(opcode, rs, rt)
begin
    if ((opcode = "000100" and rs = rt) or (opcode = "000101" and rs /= rt)) then
        bcond <= '1';
    else
        bcond <= '0';
    end if;
end process;    

-- RF connectivity (for jal, r31 <= PC + 1)
RFMUX <= rt when (RegDst = '0' and PCsrc /= "10") else "11111" when (PCSrc="10") else rd;
RFWDataMUX <= ALUout when ((MemtoReg = '0' or opcode="001111") and PCsrc /= "10") else (PCplus4) when (PCSrc="10") else DataOut;

-- ALU connectivity
-- rs or shamt for shift operations
ALUOPT <= ("000000000000000000000000000" & shamt) when (opcode="000000" and (funct = "000000" or funct = "000010")) else RFData1;
ALUMUX <= RFData2 when ALUsrc = '0' else imm;
-----------------------------------------------------------------------------------------------
-- PC+4 for next instruction
PCplus4 <= PC + 4;
    -- Program counter process
    process(clk, rst)
    -- offset address in J-Type instructions
    begin  
        if rst = '1' then
            PC <= (others => '0');
        elsif (rising_edge(clk) and ena='1') then
            if jump = '1' then
                case PCSrc is
                    when "01" => -- j (jump)
                        PC <= address;
                    when "10" => -- jal (jump and link)
                        -- r31 <= PC + 1;
                        PC <= address; 
                    when "11" => -- jr (jump register)
                        PC <= RFData1;
                    when others => -- Increment PC by 4
                        PC <= PCplus4;
                end case;
            elsif (bcond = '1' and branch = '1') then
                PC <= PCplus4 + immPC; -- Branch taken
            else
                PC <= PCplus4;  -- Branch not taken
            end if;
        elsif ena='0' then
            PC <= PC; -- Unaffected
        end if;
    end process;
    
end behav;

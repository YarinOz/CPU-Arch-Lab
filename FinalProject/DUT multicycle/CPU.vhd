library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity CPU is
    generic(Dwidth: integer := 32;
            Awidth: integer := 6;
            Regwidth: integer := 4;
            dept: integer := 64
    );

    port(clk,rst,ena: in std_logic;
         AddressBus: in std_logic_vector(Dwidth-1 downto 0);
         ControlBus: inout std_logic_vector(15 downto 0);
         DataBus: inout std_logic_vector(Dwidth-1 downto 0);
         -- Test bench signals
             -- program memory signals
        -- progMemEn: in std_logic;
        -- progDataIn: in std_logic_vector(Dwidth-1 downto 0);
        -- progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
        -- -- -- data memory signals
        -- dataMemEn, TBactive: in std_logic;
        -- dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
        -- dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
        -- dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
    );

end CPU;

architecture behav of CPU is

begin

CONTROLUNITEN: ControlUnit port map(
    clk => clk,
    rst => rst,
    RegDst => RegDst,
    MemRead => MemRead,
    MemtoReg => MemtoReg,
    MemWrite => MemWrite,
    RegWrite => RegWrite,
    Branch => Branch,
    jump => jump,
    ALUsrc => ALUsrc,
    ALUop => ALUop,
    opcode => opcode,
    funct => funct
);

DATAPATHUNIT: Datapath generic map(Dwidth) port map(
    clk => clk,
    rst => rst,
    RegDst => RegDst,
    MemRead => MemRead,
    MemtoReg => MemtoReg,
    MemWrite => MemWrite,
    RegWrite => RegWrite,
    Branch => Branch,
    jump => jump,
    ALUsrc => ALUsrc,
    ALUop => ALUop,
    opcode => opcode,
    funct => funct
);

end behav;
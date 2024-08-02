library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity CPU is
    generic(Dwidth: integer := 32;
            Awidth: integer := 5;
            Regwidth: integer := 4;
            dept: integer := 64
    );
    port(clk,rst, init: in std_logic;
         AddressBus: in std_logic_vector(Dwidth-1 downto 0);
         ControlBus: inout std_logic_vector(15 downto 0);
         DataBus: inout std_logic_vector(Dwidth-1 downto 0);
         -- Test bench signals
        -- -- program memory signals
        progMemEn: in std_logic;
        progDataIn: in std_logic_vector(Dwidth-1 downto 0);
        progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
        -- -- -- data memory signals
        dataMemEn: in std_logic;
        dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
        dataWriteAddr: in std_logic_vector(Awidth-1 downto 0);
        dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
    );

end CPU;

architecture behav of CPU is
    -- Signals for ControlUnit and Datapath connections
    signal RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: std_logic;
    signal ALUop: std_logic_vector(5 downto 0);
    signal opcode, funct: std_logic_vector(5 downto 0);
    
    -- Signals for the Datapath
    signal DataOut: std_logic_vector(Dwidth-1 downto 0);
    signal Instruction: std_logic_vector(Dwidth-1 downto 0);
    signal Address: std_logic_vector(Awidth-1 downto 0);

begin

CONTROLUNITEN: ControlUnit 
    port map(
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

DATAPATHUNIT: Datapath 
    generic map (
        Dwidth => Dwidth,
        Awidth => Awidth,
        Regwidth => Regwidth,
        dept => dept
        )
    port map(
        clk => clk,
        rst => rst,
        init => init,
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
        funct => funct,
        progMemEn => progMemEn,
        progDataIn => progDataIn,
        progWriteAddr => progWriteAddr,
        dataMemEn => dataMemEn,
        dataDataIn => dataDataIn,
        dataWriteAddr => dataWriteAddr,
        dataDataOut => DataOut
);
-- for writing the data to the output port
dataDataOut <= DataOut;

end behav;
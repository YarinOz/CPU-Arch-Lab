library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity CPU is
    generic(Dwidth: integer;
            Awidth: integer;
            Regwidth: integer;
            sim: boolean
    );
    port(clk,rst, ena: in std_logic;
         AddressBus: out std_logic_vector(Awidth-1 downto 0);
         ControlBus: out std_logic_vector(15 downto 0);-- optional
         DataBus: inout std_logic_vector(Dwidth-1 downto 0);
         INTA: out std_logic;
         INTR: in std_logic
    );

end CPU;

architecture behav of CPU is
    -- Signals for ControlUnit and Datapath connections
    signal RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: std_logic;
    signal ALUop: std_logic_vector(5 downto 0);
    signal opcode, funct: std_logic_vector(5 downto 0);
    signal PCSrc: std_logic_vector(1 downto 0);
    
    -- Signals for the Datapath
    signal GIE: std_logic;
    signal zeros: std_logic_vector(12 downto 0);

begin

zeros <= (others => '0');

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
        PCSrc => PCSrc,
        opcode => opcode,
        funct => funct
);

DATAPATHUNIT: Datapath 
    generic map (
        Dwidth => Dwidth,
        Awidth => Awidth,
        Regwidth => Regwidth,
        sim => sim
        )
    port map(
        clk => clk,
        rst => rst,
        ena => ena,
        RegDst => RegDst,
        MemRead => MemRead,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        RegWrite => RegWrite,
        Branch => Branch,
        jump => jump,
        ALUsrc => ALUsrc,
        ALUop => ALUop,
        PCSrc => PCSrc,
        opcode => opcode,
        funct => funct,
        AddrBus => AddressBus,
        DataBus => DataBus,
        GIE => GIE,
        INTA => INTA,
        INTR => INTR
);

-- need to add the control bus to the port map (WIP)
ControlBus <= zeros & GIE & MemWrite & MemRead;

end behav;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity top is
    generic(Dwidth: integer := 16;
            Awidth: integer := 6;
            Regwidth: integer := 4;
            dept: integer := 64
    );

    port(clk,rst,ena: in std_logic;
         done_FSM: out std_logic;
         -- Test bench signals
             -- program memory signals
        progMemEn: in std_logic;
        progDataIn: in std_logic_vector(Dwidth-1 downto 0);
        progWriteAddr: in std_logic_vector(Awidth-1 downto 0);
        -- -- data memory signals
        dataMemEn, TBactive: in std_logic;
        dataDataIn: in std_logic_vector(Dwidth-1 downto 0);
        dataWriteAddr, dataReadAddr: in std_logic_vector(Awidth-1 downto 0);
        dataDataOut: out std_logic_vector(Dwidth-1 downto 0)
    );

end top;

architecture behav of top is
    -- status signals
    signal st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: std_logic;
    -- control signals
    signal Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in: std_logic;
    signal PCsel, Rfaddr: std_logic_vector(1 downto 0);
    signal OPC: std_logic_vector(3 downto 0);

begin

CONTROLUNITEN: ControlUnit port map(
    clk => clk,
    rst => rst,
    st => st,
    ld => ld,
    mov => mov,
    done => done,
    add => add,
    sub => sub,
    jmp => jmp,
    jc => jc,
    jnc => jnc,
    andf => andf,
    orf => orf,
    xorf => xorf,
    Cflag => Cflag,
    Zflag => Zflag,
    Nflag => Nflag,
    un1 => un1,
    un2 => un2,
    un3 => un3,
    un4 => un4,
    Mem_wr => Mem_wr,
    Mem_out => Mem_out,
    Mem_in => Mem_in,
    Cout => Cout,
    Cin => Cin,
    Ain => Ain,
    RFin => RFin,
    RFout => RFout,
    IRin => IRin,
    PCin => PCin,
    Imm1_in => Imm1_in,
    Imm2_in => Imm2_in,
    PCsel => PCsel,
    Rfaddr => Rfaddr,
    OPC => OPC,
    ena => ena,
    done_FSM => done_FSM
);

DATAPATHUNIT: Datapath generic map(Dwidth) port map(
    TBactive => TBactive,
    clk => clk,
    rst => rst,
    Mem_wr => Mem_wr,
    Mem_out => Mem_out,
    Mem_in => Mem_in,
    Cout => Cout,
    Cin => Cin,
    Ain => Ain,
    RFin => RFin,
    RFout => RFout,
    IRin => IRin,
    PCin => PCin,
    Imm1_in => Imm1_in,
    Imm2_in => Imm2_in,
    PCsel => PCsel,
    Rfaddr => Rfaddr,
    OPC => OPC,
    st => st,
    ld => ld,
    mov => mov,
    done => done,
    add => add,
    sub => sub,
    jmp => jmp,
    jc => jc,
    jnc => jnc,
    andf => andf,
    orf => orf,
    xorf => xorf,
    Cflag => Cflag,
    Zflag => Zflag,
    Nflag => Nflag,
    un1 => un1,
    un2 => un2,
    un3 => un3,
    un4 => un4,
    progMemEn => progMemEn,
    progDataIn => progDataIn,
    progWriteAddr => progWriteAddr,
    dataMemEn => dataMemEn,
    dataDataIn => dataDataIn,
    dataWriteAddr => dataWriteAddr,
    dataReadAddr => dataReadAddr,
    dataDataOut => dataDataOut
);

end behav;
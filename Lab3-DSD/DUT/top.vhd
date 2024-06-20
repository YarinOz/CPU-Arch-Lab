library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity top is
    generic(Dwidth: integer := 16;
            Awidth: integer := 6;
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

CONTROLUNIT: Control port map(
    clk, rst, st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4, 
    Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,
    PCsel, Rfaddr, OPC, done_FSM
);
DATAPATHUNIT: Datapath generic map(Dwidth) port map(TBactive, clk, rst, Mem_wr,Mem_out,Mem_in,
    Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,
    PCsel, Rfaddr, OPC, st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4, 
    progMemEn, progDataIn, progWriteAddr, dataMemEn, dataDataIn, dataWriteAddr, dataReadAddr, dataDataOut
);

end behav;
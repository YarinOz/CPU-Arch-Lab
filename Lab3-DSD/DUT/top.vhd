library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;

entity top is
    generic(bus_size: integer := 16;);

    port(clk,rst,ena: in std_logic;
         done: out std_logic;
         -- tb data in/out
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

CONTROLUNIT: Control port map(clk, rst, st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4, Mem_wr, Mem_out, Mem_in,
Cout, Cin, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in, PCsel, Rfaddr, OPC);

DATAPATH: Datapath port map(clk, rst, Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,
PCsel, Rfaddr, OPC, st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4);

end behav;
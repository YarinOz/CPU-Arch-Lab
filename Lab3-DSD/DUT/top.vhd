library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.aux_package.all;
entity top is
    generic(bus_size: integer := 16;);

    port(clk,rst,ena: in std_logic;
         Datain: in std_logic_vector(bus_size-1 downto 0);
         Dataout: out std_logic_vector(bus_size-1 downto 0);
         done: out std_logic;);
end top;

architecture behavior of top is
    -- signal Mem_wr,Mem_out,Men_in,Cout,Cin,Ain,RFin,RFout,Rfaddr,IRin,PCin,Imm1_in,Imm2_in :std_logic;
    -- signal PCsel: std_logic_vector(1 downto 0);
    -- signal OPC: std_logic_vector(3 downto 0);
    signal Control: std_logic_vector(3 downto 0);
    signal Status: std_logic_vector(3 downto 0);
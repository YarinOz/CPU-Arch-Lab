library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity ControlUnit is
    port(
        clk: in std_logic;
        rst: in std_logic;
        opcode, funct: in std_logic_vector(5 downto 0);
        -- Control signals for the datapath
        RegDst, MemRead, MemtoReg, MemWrite, RegWrite, Branch, jump, ALUsrc: out std_logic;
        ALUop: out std_logic_vector(5 downto 0)
    );
end ControlUnit;

architecture behavioral of ControlUnit is
    signal RType: std_logic;
begin
    -- RType: add, addu, sub, and, or, xor, slt, sll, srl, jr
    RType <= '1' when opcode = "000000" else '0';

    -- OPC decoder 
    RegDst <= '1' when RType = '1' else '0';
    -- branch: beq, bne
    Branch <= '1' when (opcode="000100" or opcode="000101") else '0';
    -- MemRead: lw
    MemRead <= '1' when opcode = "100011" else '0';
    MemtoReg <= MemRead;
    -- MemWrite: sw
    MemWrite <= '1' when opcode = "101011" else '0';
    -- Regwrite: in all but: j, jal, jr, beq, bne, sw
    RegWrite <= '0' when ((RType='1' and funct="001000") or opcode = "000010" or opcode = "000011" or opcode = "000100" or opcode = "000101" or opcode = "101011") else '1';
    -- jump: j, jal, jr
    jump <= '1' when (opcode="000010" or opcode="000011" or (RType='1' and funct="001000")) else '0';
    -- ALUsrc: sw,addi,slti,andi,ori,xori,sll,srl : 1, add,addu,sub,and,or,xor,slt : 0
    ALUsrc <= '1' when (opcode = "101011" or opcode = "001000" or opcode = "001010" or opcode = "001100" or opcode = "001101" or opcode = "001110" or (RType='1' and (funct = "000000" or funct = "000010"))) else '0';
    ALUop <= funct when RType='1' else opcode; -- ALU control signal

end behavioral;

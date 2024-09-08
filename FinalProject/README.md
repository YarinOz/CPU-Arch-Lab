# CPU and Hardware Accelerators - Final Project

- remove delta in TB: configure list -delta collapse
- Compiled using VHDL_2008
- Project: top : MCU, Add PLL (50MHz to 25MHz normal mode) 

## notes to keep:
1. For sim init the memory manually in datapath and use tb_FILE.
2. SW9 is for ena and SW8-SW0 is for operands
3. Reset is connected to KEY0

## ISA supports
### R-Type
sll 
srl
jr- opc=000000, funct=001000
add
sub
mul
and
or
xor
slt
### I-Type
beq
bne
addi
slti
andi
ori
xori
lui- opc=001111
lw
sw
### J-Type
j
jal- opc=000011

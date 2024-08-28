# CPU and Hardware Accelerators - Final Project

-- remove delta in TB: configure list -delta collapse
-- Compiled using VHDL_2008
-- Project: top:MCU, Add PLL (50MHz to 25MHz normal mode) 
!! fix read data from bus (SW INPUT)

## notes to do:
1. now working with minimal ALU
2. finish Interrupt controller
3. add basic timer
4. SW9 is for ena and SW8-SW0 is for operands

## notes to keep:
1. in order to init the memory manually use tb_FILE.
2. ISA is ready, left to connect HW accelerators
3. theres a small delay before update of btcnt from clked btcnt due to clocks not being synchronized

! ask HANAN: 
ISMC burn ITCM.HEX and DTCM.hex after logical burn
running QA using endless loop burning hex files to build and running
Interrupt: loading type and jumping (jal isr_label)

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

# CPU and Hardware Accelerators - Final Project

-- remove delta in TB: configure list -delta collapse

## notes to do:
1. now working with minimal ALU
2. understand memory interface
3. connect the tri-bus with IO
4. add HW accelerators
5. add FPGA IO conective layer
5. add GPIO and basic timer

## notes to keep:
1. in order to init the memory manually use tb_CPU.


## tb_CPU
lw $4,0($1)
addi $
sw 

-- slt, slti if needed change 1 location
## ISA supports
### R-Type
sll 
srl
jr-
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
lui-
lw
sw
### J-Type
j
jal-
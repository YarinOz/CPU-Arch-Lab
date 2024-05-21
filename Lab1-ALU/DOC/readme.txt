# Lab 1: VHDL Concurrent Code - ALU

- Develop skills in VHDL, focusing on code structure, data types, operators and attributes, concurrent code, design hierarchy, packages, and components.
- Gain basic skills in ModelSim, a multi-language HDL simulation environment.

System module contain:

Inputs:
- X
- Y
- ALUFN: control signal where [4:3] is a sub-module select (01-AdderSub, 10-Shifter, 11-Logic)
  and [2:0] configures each module.

Outputs:
- ALUOUT: The systems output.
- Flags: N_flag(negative), Z_flag(zero), C_flag(carry), OF_flag(over-flow).

## AdderSub
This module supports 3 operations: 
- Addition (Y+X): sub_c='0' (determined by ALUFN[2:0]='000')
- Subtraction (Y-X): sub_c='1' (determined by ALUFN[2:0]='001') 
- Negative (-X): Y='0..0', sub_c='1' (determined by ALUFN[2:0]='010') 
The AdderSub is implemented using FA's for a ripple-adder.

## Logic
This module supports 7 operations (determined by ALUFN[2:0]):
Not(Y):'000', Y OR X: '001', Y AND X: '010', Y XOR X: '011', 
Y NOR X: '100', Y NAND X: '101', Y XNOR X: '111'.

## Shifter
This module supports 2 operations: 
- Shift left: Shift Y left by X times (determined by ALUFN[2:0]='000')
- Shift right: Shift Y right by X times (determined by ALUFN[2:0]='001')
The shifter is implemented using n-bit barrel shifter, carry is last shifted value.

## Top
This module envelops the entire system, connecting the different modules.

## FA
Full-Adder is a 1-bit adder used by the AdderSub module as a base module.

## Aux_package
A package containing the different components.

## Credits
This Lab is by Yarin Oziel and Itay Kandil
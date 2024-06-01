# Lab 2: VHDL Sequential Code - behavioral modeling

- Develop skills in VHDL part 2, focusing on sequential code and behavioral modeling.
- Enhance knowledge in digital systems design.
- Properly analyze and understand architecture design.
- In this laboratory we will design a synchronous digital system which detects valid sub series for a given 
  condition value.

System module contain:

Inputs:
- X
- DetectionCode
- clk
- rst
- ena

Outputs:
- detector

## Adder
This module supports addition and subtraction operations using Two's compliment.
(used to calculate the difference diff = x[j-1]-x[j-2])

## Top
This module envelops the entire system, connecting the different modules.
(The processes are triggered by a clock even, rising edge)
When enable is high and reset is low the system begins to operate in the following manner:

  1. calculate the difference: diff = x[j-1]-x[j-2] where j-i is i cycles before j
  2. a successfull event happens when two conditions are met: DetectionCode=i and diff=i+1 where i=0,1,2,3
  3. uppon m successfull events the detector outputs a high signal ('1'), else a low signal ('0')


## Aux_package
A package containing the different components.

## Credits
This Lab is by Yarin Oziel and Itay Kandil
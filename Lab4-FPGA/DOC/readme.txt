LAB4 - FPGA based Digital Design
this lab's main goal is to  use   lab 1 alu module along with a basic  double input pwm unit and create  a synchronous digital system  synthesized using the  Cyclone V FPGA  with regard to performance
hardware minimalism and clock frequency  




the input signals of the system are : 
 X :  first operand
 Y :  second operand
 ALU_func : alu function code - chooses the desired function of the pwm/ alu unit 
 rst : asynchronous reset enabler
 clk : the clock of the system 
ena : enabling the usage of the pwm unit 




the output signals of the system are : 
ALU_out :  result output of alu module (asynchronous)
z,n,c,of flags : flags stating   the properties of the alu result (asynchronous)
PWM_out : output of the pwm unit , either “1” or “0” (synchronous)






included vhd files :






IO_interface.vhd- file containing the interface between the hardware components ( such as lcd , switches and led ) and the system 




top.vhd- the entity that envelopes the entire system  connecting the the  different inputs to the submodules




 ALU.vhd-  the first  module , based on lab 1 architecture.
 it includes 3 sub modules ( the output is selected from one of the 3 submodules (determined by ALUFN[3:4]) : 


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


PWM.vhd - the pwm unit , consists of two processes : the first one  increments the counter in each rising edge and the second one checks if the counter has reached either x  or y values and outputs the according signal




counterEnvelope.vhd - as its name suggests , it envelopes the clock counter ( discussed next)- meaning it takes the 50 mega hertz clock inputted by the fpga and outputs  a 2 mega hertz clock using a pll


counter.vhd - this unit receives the 2 mega hertz clock outputted from the counterEnvelope unit and signaling a logic “1” each 2^6 
“ counterEnvelope clocks” basically diving the last clock by 64 - resulting in the desired 31.25 k hertz clock . this clock feeds the entire system.




7segementdecoder.vhd - decodes the input into the  desired std_logic_vector . this bit vector outputs the desired digit on the lcd screens on top of the fpga card .




aux_package.vhd - includes all the different components used in the system




registerALU.vhd - this file is used to determine the fmax of the alu module , its difference from the basic ALU.vhd  is the inputs and outputs being saved in designated registers.
















.
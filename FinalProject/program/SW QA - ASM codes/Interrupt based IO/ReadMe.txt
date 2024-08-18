=======================================================================================
					Description of the source code test1.asm:
=======================================================================================
Input:  KEY3, KEY2, KEY1
Output: PORT_HEX0[7-0],PORT_HEX1[7-0],PORT_HEX2[7-0],PORT_HEX3[7-0],PORT_HEX4[7-0],
		PORT_HEX5[7-0],PORT_LEDR[7-0]
RESET:  Pushbutton KEY0
----------------------------------------------------------------------------------------
On KEY1 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX0[7-0],PORT_HEX1[7-0],PORT_LEDR[7-0]

On KEY2 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX2[7-0],PORT_HEX3[7-0],PORT_LEDR[7-0]

On KEY3 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX4[7-0],PORT_HEX5[7-0],PORT_LEDR[7-0]
========================================================================================
					Description of the source code test2.asm:
========================================================================================
Input:  KEY3, KEY2, KEY1
Output: PORT_LEDR[7-0]
RESET:  Pushbutton KEY0
----------------------------------------------------------------------------------------
On reset - counting up by 1 in frequency of 50MHz/2^26
On KEY1 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/4/2^22=50MHz/2^24

On KEY2 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/2/2^21=50MHz/2^22

On KEY3 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/8/2^26=50MHz/2^29
========================================================================================
					Description of the source code test3.asm:
========================================================================================
Input:  KEY3, KEY2, KEY1
Output: PORT_LEDR[7-0]
RESET:  Pushbutton KEY0
----------------------------------------------------------------------------------
On KEY1 pushing:
---------------
loading DIVIDEND with 8-bit value from PORT_SW[7-0]

On KEY2 pushing:
---------------
loading DIVISOR with 8-bit value from PORT_SW[7-0]

On KEY3 pushing:
---------------
loading DIVIDEND with 8-bit value of y=0x00D7C88F=14,141,583
loading DIVISOR with 8-bit value of x=0x0000F8D4=63,700
Note: y/x={QUOTIENT=0xDE=222 ,RESIDUE=0xB7=183}
					
On Divider Accelerator interrupt:
--------------------------------
write QUOTIENT low nibble to PORT_HEX4[7-0]
write QUOTIENT high nibble to PORT_HEX5[7-0]
write RESIDUE to PORT_LEDR[7-0]
==================================================================================
					Description of the source code test4.asm:
==================================================================================
Input:  KEY3, KEY2, KEY1
Output: PORT_HEX0[7-0],PORT_HEX1[7-0],PORT_HEX2[7-0],PORT_HEX3[7-0],PORT_HEX4[7-0],
		PORT_HEX5[7-0],PORT_LEDR[7-0]
RESET:  Pushbutton KEY0
----------------------------------------------------------------------------------
on RESET:
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/2^26
for MCLK=50MHz we get PWMout=50MHz/1000=5kHz with Duty Cycle=25% 

On KEY1 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/4/2^20=50MHz/2^22=1.19Hz i.e. 0.84sec
for MCLK=50MHz we get PWMout=50MHz/4/1000=1.25kHz with Duty Cycle=75%
loading DIVIDEND with 8-bit value from PORT_SW[7-0]

On KEY2 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/2/2^24=50MHz/2^25=0.15Hz i.e. 6.7sec
for MCLK=50MHz we get PWMout=50MHz/2/1000=2.5kHz with Duty Cycle=25%
loading DIVISOR with 8-bit value from PORT_SW[7-0]

On KEY3 pushing:
---------------
counting up by 1 onto PORT_LEDR[7-0] in frequency of 50MHz/8/2^16=50MHz/2^19=9.54Hz i.e. 0.104sec

for MCLK=50MHz we get PWMout=50MHz/8/1000=625Hz with Duty Cycle=75%
loading DIVIDEND with 8-bit value of y=0x00D7C88F=14,141,583
loading DIVISOR with 8-bit value of x=0x0000F8D4=63,700

Note: y/x={QUOTIENT=0xDE=222 ,RESIDUE=0xB7=183}

On Divider Accelerator interrupt:
--------------------------------
write QUOTIENT low nibble to PORT_HEX4[7-0]
write QUOTIENT high nibble to PORT_HEX5[7-0]


									

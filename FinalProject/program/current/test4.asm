#--------------------------------------------------------------
#		    MEMORY Mapped I/O
#--------------------------------------------------------------
#define PORT_LEDR[7-0] 0x800 - LSB byte (Output Mode)
#------------------- PORT_HEX0_HEX1 ---------------------------
#define PORT_HEX0[7-0] 0x804 - LSB byte (Output Mode)
#define PORT_HEX1[7-0] 0x805 - LSB byte (Output Mode)
#------------------- PORT_HEX2_HEX3 ---------------------------
#define PORT_HEX2[7-0] 0x808 - LSB byte (Output Mode)
#define PORT_HEX3[7-0] 0x809 - LSB byte (Output Mode)
#------------------- PORT_HEX4_HEX5 ---------------------------
#define PORT_HEX4[7-0] 0x80C - LSB byte (Output Mode)
#define PORT_HEX5[7-0] 0x80D - LSB byte (Output Mode)
#--------------------------------------------------------------
#define PORT_SW[7-0]   0x810 - LSB byte (Input Mode)
#---------------------- Data Segment --------------------------
.data 
	x: 	.word 0x09
	y: 	.word 0x10
	N: 	.word 0xFFFF
.text
main:	addi $sp,$zero,0x800  	# $sp=0x800
	lw   $t1,N
	lw   $a0,x
	lw   $a1,y
	jal  func
	sw   $v0,0x800 		# write to PORT_LEDR[7-0]
L:	j L            		# infinite loop
	
func:	addi $sp,$sp,-8
	sw   $ra,0($sp) 	
	add  $t0,$a0,$a1 	# $t0=x+y
	sw   $t0,4($sp)
	jal  calc 
	slt  $t0,$0,$v0		# if $0<v0 than $t0=1 
	bne  $t0,$0,exit
	lw   $v0,4($sp)
exit:	lw   $ra,0($sp) 
	addi $sp,$sp,8	 
	jr   $ra        	# ret
	
calc:	addi $v0,$t0,-4		# $v0=$t0-4=x+y-4
	jr   $ra		# ret	
	
	

       
         

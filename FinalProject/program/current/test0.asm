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
#--------------------------------------------------------------

.data 
	N: .word 0x0004 
.text
	lw   $t3,N
	lw   $t0,0x810 # read the state of PORT_SW[7-0]
	# move $t0,$zero  # $t0=0
	
Loop:	sw   $t0,0x800 # write to PORT_LEDR[7-0]
	sw   $t0,0x804 # write to PORT_HEX0[7-0]
	sw   $t0,0x805 # write to PORT_HEX1[7-0]
	sw   $t0,0x808 # write to PORT_HEX2[7-0]
	sw   $t0,0x809 # write to PORT_HEX3[7-0]
	sw   $t0,0x80C # write to PORT_HEX4[7-0]
	sw   $t0,0x80D # write to PORT_HEX5[7-0]
	
	addi $t0,$t0,1 # $t0=$t0+1
	move $t1,$zero  # $t1=0
delay:	addi $t1,$t1,1  # $t1=$t1+1
	slt  $t2,$t1,$t3      #if $t1<N than $t2=1
	beq  $t2,$zero,Loop   #if $t1>=N then go to Loop label
	j   delay



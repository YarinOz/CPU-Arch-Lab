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
	N: .word 0xB71B00
.text
	sw   $0,0x800 # write to PORT_LEDR[7-0]
	sw   $0,0x804 # write to PORT_HEX0[7-0]
	sw   $0,0x805 # write to PORT_HEX1[7-0]
	sw   $0,0x808 # write to PORT_HEX2[7-0]
	sw   $0,0x809 # write to PORT_HEX3[7-0]
	sw   $0,0x80C # write to PORT_HEX4[7-0]
	sw   $0,0x80D # write to PORT_HEX5[7-0]
	#--------------------------------------------------
	lw   $t3,N
	move $t0,$zero  # $t0=0
	addi $t5,$zero,1  # $t5=1
Loop:	lw   $t4,0x810 # read the state of PORT_SW[7-0]
	andi $t2,$t4,0x01
	bne  $t2,$zero,Loop1   #if $t2!=0 then go to Loop label
	andi $t2,$t4,0x02
	bne  $t2,$zero,Loop2   #if $t2!=0 then go to Loop label
	j    Loop
	
Loop1:	add  $t0,$t0,$t5  # $t0=$t0+$t5
	sll  $t0,$t0,1 # $t0=$t0*2
	sw   $t0,0x800 # write to PORT_LEDR[7-0]
	sw   $t0,0x804 # write to PORT_HEX0[7-0]
	sw   $t0,0x805 # write to PORT_HEX1[7-0]
	sw   $t0,0x808 # write to PORT_HEX2[7-0]
	sw   $t0,0x809 # write to PORT_HEX3[7-0]
	sw   $t0,0x80C # write to PORT_HEX4[7-0]
	sw   $t0,0x80D # write to PORT_HEX5[7-0]
	j    delay
	
Loop2:	sub  $t0,$t0,$t5  # $t0=$t0-$t5
	sll  $t0,$t0,1 # $t0=$t0*2
	sw   $t0,0x800 # write to PORT_LEDR[7-0]
	sw   $t0,0x804 # write to PORT_HEX0[7-0]
	sw   $t0,0x805 # write to PORT_HEX1[7-0]
	sw   $t0,0x808 # write to PORT_HEX2[7-0]
	sw   $t0,0x809 # write to PORT_HEX3[7-0]
	sw   $t0,0x80C # write to PORT_HEX4[7-0]
	sw   $t0,0x80D # write to PORT_HEX5[7-0]
	#j    delay
	
delay:	move $t1,$zero  # $t1=0
L:	addi $t1,$t1,1  # $t1=$t1+1
	slt  $t2,$t1,$t3      #if $t1<N than $t2=1
	beq  $t2,$zero,Loop   #if $t1>=N then go to Loop label
	j    L



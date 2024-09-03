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
#define PORT_KEY[3-1]  0x814 - LSB nibble (3 push-buttons - Input Mode)
#--------------------------------------------------------------
#define UCTL           0x818 - Byte 
#define RXBF           0x819 - Byte 
#define TXBF           0x81A - Byte
#--------------------------------------------------------------
#define BTCTL          0x81C - LSB byte 
#define BTCNT          0x820 - Word 
#define BTCCR0         0x824 - Word 
#define BTCCR1         0x828 - Word 
#--------------------------------------------------------------
#define DIVIDEND       0x82C - Word
#define DIVISOR        0x830 - Word
#define QUOTIENT       0x834 - Word
#define RESIDUE        0x838 - Word
#--------------------------------------------------------------
#define IE             0x83C - LSB byte 
#define IFG            0x83D - LSB byte
#define TYPE           0x83E - LSB byte
#---------------------- Data Segment --------------------------
.data 
	IV: 	.word main            # Start of Interrupt Vector Table
		.word UartRX_ISR
		.word UartRX_ISR
		.word UartTX_ISR
	        .word BT_ISR
		.word KEY1_ISR
		.word KEY2_ISR
		.word KEY3_ISR
		.word DIVIDER_ISR

	N:	.word 0xB71B00
	y:      .word 0xC71D09
	x:      .word 0x001D09
	Q:	.space 4	# allocates 4 bytes = word of space, usually initialized to 0	
#---------------------- Code Segment --------------------------	
.text
main:	addi $sp,$zero,0x800 		# $sp=0x800
	move $t3,$zero       		# $t3=0
	addi $t0,$zero,0x26  
	sw   $t0,0x81C       		# BTCTL=0x26(BTHOLD=1,BTIP=6)
	sw   $0,0x820        		# BTCNT=0
	sw   $0,0x83C        		# IE=0
	sw   $0,0x83D        		# IFG=0
	addi $t0,$zero,0x02  
	sw   $t0,0x81C       		# BTCTL=0x06(BTHOLD=0,BTIP=7, 50MHz/2^26)

	addi $t0,$zero,0x3E8
	sw   $t0,0x824        		# CCR0
	srl  $t0,$t0,2
	sw   $t0,0x828        		# CCR1

	addi $t0,$zero,0x7C 
	sw   $t0,0x83C        		# IE=0x7C
	
	lw   $t2,x
	lw   $t4,y
	sw   $t4,0x82C	     		# load DIVIDEND with y value
	sw   $t2,0x830	     		# load DIVISOR with x value
	
	ori  $k0,$k0,0x01     		# EINT, $k0[0]=1 uses as GIE
	
L:	j    L  	     		# infinite loop
	
KEY1_ISR:
	addi $t0,$zero,0x15  
	sw   $t0,0x81C       		# BTCTL=0x15(BTHOLD=0, BTSSEL=2, BTIP=5, 50MHz/4/2^22)
	
	lw   $t1,0x83D 			# read IFG
	andi $t1,$t1,0xFFF7 
	sw   $t1,0x83D 			# clr KEY1IFG
	jr   $k1       			# reti
	
KEY2_ISR:
	addi $t0,$zero,0x0D  
	sw   $t0,0x81C       		# BTCTL=0x0D(BTHOLD=0,BTSSEL=1,BTIP=5,50MHz/2/2^21)
	
	lw   $t1,0x83D  		# read IFG
	andi $t1,$t1,0xFFEF 
	sw   $t1,0x83D  		# clr KEY2IFG
	jr   $k1        		# reti

KEY3_ISR:
	addi $t0,$zero,0x1F  
	sw   $t0,0x81C       		# BTCTL=0x1F(BTHOLD=0,BTSSEL=3,BTIP=7,50MHz/8/2^26)
	
	lw   $t1,0x83D  		# read IFG
	andi $t1,$t1,0xFFDF 
	sw   $t1,0x83D  		# clr KEY3IFG
	jr   $k1        		# reti
		
BT_ISR:	addi $t3,$t3,1  		# $t3=$t3+1
	sw   $t3,0x800 			# write to PORT_LEDR[7-0]
        jr   $k1        		# reti
        
DIVIDER_ISR:
	lw   $t5,0x834 			# read QUOTIENT value to $t5
	sw   $t5,Q
	sw   $t5,0x800 			# write to PORT_LEDR[7-0]
	jr   $k1        		# reti
	
UartRX_ISR:	jr   $k1        	# reti            

UartTX_ISR:	jr   $k1        	# reti 

         

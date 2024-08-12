# Program starts at address 0x00000000
.text
main:
    # Load values from data memory into registers
    lw $a0, 0x0001($zero)    # $a0 = DTCM[0x0001] = 10
    addi $a1, $zero, 15      # $a1 = 15

    # R-Type Instructions
    sll $t0, $a0, 1          # $t0 = $a0 << 1 = 20
    srl $t1, $a0, 1          # $t1 = $a0 >> 1 = 5
    add $t3, $a0, $a1        # $t3 = $a0 + $a1 = 25
    sub $t4, $a0, $a1        # $t4 = $a0 - $a1 = -5 (0xFFFFFFFB)
    mul $t5, $a0, $a1        # $t5 = $a0 * $a1 = 150
    and $t7, $a0, $a1        # $t7 = $a0 & $a1 = 10
    or $t8, $a0, $a1         # $t8 = $a0 | $a1 = 15
    xor $t9, $a0, $a1        # $t9 = $a0 ^ $a1 = 5

    # Infinite loop to end the program
loop:
    j loop

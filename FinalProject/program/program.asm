# Program starts at address 0x00000000
.text
main:
    # Load values from data memory into registers
    lw $a0, 0x0001($zero)    # $a0 = DTCM[0x0001] = 10
    addi $a1, $zero, 7       # $a1 = 7
    sw $a1, 0x0002($zero)    # Store 7 in DTCM[0x0002]

    # R-Type Instructions
    sll $t0, $a0, 1          # $t0 = $a0 << 1 = 20
    srl $t1, $a0, 1          # $t1 = $a0 >> 1 = 5
    add $t2, $a0, $a1        # $t2 = $a0 + $a1 = 17
    sub $t3, $a1, $a0        # $t3 = $a1 - $a0 = FFFFFFFF (negative 10)
    mul $t4, $a0, $a1        # $t4 = $a0 * $a1 = 70
    and $t5, $a0, $a1        # $t5 = $a0 & $a1 = 2
    or $t6, $a0, $a1         # $t6 = $a0 | $a1 = 15
    xor $t7, $a0, $a1        # $t7 = $a0 ^ $a1 = 3
    slt $t8, $a0, $a1        # $t8 = ($a0 < $a1) ? 1 : 0 = 1

    # I-Type Instructions
    beq $a0, $a1, skip       # If $a0 == $a1, skip next instruction
    bne $a0, $a1, next       # If $a0 != $a1, go to next
    addi $t9, $a0, 3         # $t9 = $a0 + 3 = 13
    slti $t9, $a0, 4         # $t9 = ($a0 < 4) ? 1 : 0 = 0
    andi $t9, $a0, 1         # $t9 = $a0 & 1 = 0
    ori $t9, $a0, 8          # $t9 = $a0 | 8 = 10
    xori $t9, $a0, 3         # $t9 = $a0 ^ 3 = 9
    lui $t9, 0x1234          # $t9 = 0x12340000
    lw $t9, 0x0002($zero)    # $t9 = DTCM[0x0002] = 7
    sw $t9, 0x0004($zero)    # Store $t9 (7) in DTCM[0x0004]

skip:
    # J-Type Instructions
    j done                   # Jump to done

next:
    # Additional R-Type: jr
    jal subroutine           # Jump and link to subroutine
    jr $ra                   # Jump back to return address

subroutine:
    add $v0, $a0, $a1        # $v0 = $a0 + $a1 = 17
    jr $ra                   # Return to caller

done:
    # Infinite loop to end the program
    j done

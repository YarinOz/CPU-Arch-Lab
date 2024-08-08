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
    slt $t2, $a0, $a1        # $t2 = ($a0 < $a1) ? 1 : 0
    beq $a0, $a1, label_eq   # Branch if $a0 == $a1
    bne $a0, $a1, label_ne   # Branch if $a0 != $a1
    addi $t3, $a0, 5         # $t3 = $a0 + 5
    slti $t4, $a0, 20        # $t4 = ($a0 < 20) ? 1 : 0
    andi $t5, $a0, 0x0F      # $t5 = $a0 & 0x0F
    ori $t6, $a0, 0xF0       # $t6 = $a0 | 0xF0
    xori $t7, $a0, 0xFF      # $t7 = $a0 ^ 0xFF
    lui $t8, 0x1234          # $t8 = 0x12340000
    lw $t9, 0x0004($a0)      # Load word from memory address ($a0 + 4)
    sw $t9, 0x0008($a0)      # Store word to memory address ($a0 + 8)
    j label_end               # Jump to label_end
    jal label_subroutine      # Jump and link to label_subroutine

label_eq:
    # Code to execute if $a0 == $a1
    j label_end

label_ne:
    # Code to execute if $a0 != $a1
    j label_end

label_subroutine:
    # Code for subroutine
    jr $ra                    # Return from subroutine

label_end:
    # Infinite loop to end the program
    j label_end

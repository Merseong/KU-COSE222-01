.text
.align 4
main:

addi $3, $0, 0x800
add $3, $3, $3
add $3, $3, $3
lui $2, 0xFFFF
or  $2, $3, $2     /* $2 contains 0xFFFF_2000, which is GPIO base address */
bne $2, $2, error

la  $sp, my_stack
sw  $2, 0($sp)     /* store 0xFFFF_2000 to stack */

/* display 8 on HEX0 */
la  $9, SEG8
lw  $10, ($9)
lw  $3, ($sp)
sw  $10, 0xC($3)

/* display 7 on HEX1 */
lw  $10, -4($9)
lw  $3, ($sp)
add $3, $3, 0x10   /* $3 contains 0xFFFF_2010 */
sw  $10, ($3)

nop                /* nop will be filled in the delay slot (after beq) when compiled */
beq $3, $0, error  /* $3:0xFFFF_2010, should be not-taken */

/* display 6 on HEX2 */
lw  $3, ($sp)
add $3, $3, 0x14   /* $3 contains 0xFFFF_2014 */
lw  $10, -8($9)
sw  $10, ($3)

/* display 5 on HEX3 */
lw  $10, -12($9)
addi $3, $3, 4     /* $3 contains 0xFFFF_2018 */
sw  $10, ($3)

nop                /* nop will be filled in the delay slot (after j) when compiled */
j   HEX3
add  $9, $9, 8     /* should not be executed */

HEX0:
/* display 4 on HEX0 */
lw  $10, -16($9)
lw  $3, ($sp)
add $3, $3, 0xC   	/* $3 contains 0xFFFF_200C */
sw  $10, ($3)

/* display 3 on HEX1 */
lw  $10, -20($9)
addi $3, $3, 4     /* $3 contains 0xFFFF_2010 */
sw  $10, ($3)

/* display 2 on HEX2 */
lw  $10, -24($9)
addi $4, $0, 4
add  $3, $3, $4    /* $3 contains 0xFFFF_2014 */
sw  $10, ($3)

nop                /* nop will be filled in the delay slot (after jr) when compiled */
jr  $ra            /* return to forever */

HEX3:
/* display 1 on HEX3 */
lw  $10, -28($9)
lw  $3, ($sp)
addi $3, $3, 0x8
addi $3, $3, 0x10   /* $3 contains 0xFFFF_2018 */
sw  $10, ($3)

nop                 /* nop will be filled in the delay slot (after jal) when compiled */
jal HEX0

forever:
	j forever

error:
	j error

.data
.align 4
SEG0:  .word  0x40
SEG1:  .word  0x79
SEG2:  .word  0x24
SEG3:  .word  0x30
SEG4:  .word  0x19
SEG5:  .word  0x12
SEG6:  .word  0x02
SEG7:  .word  0x78
SEG8:  .word  0x00

my_stack:
       .space 1024

#
#  Author: Taeweon Suh
#  Date: Sep. 18, 2009
#  Description: Simple addition of 4 words (result = op1 + op2)
#

.text
.align 4

main:
	la   $t0, op1
	la   $t1, op2
	la   $t2, result
	subu $t3, $t1, $t0 
	sra  $t3, $t3, 2   # how many words? shift right by 2

myloop:
	lw   $s0, 0($t0)
	lw   $s1, 0($t1)
	add  $s2, $s1, $s0
	sw   $s2, 0($t2)
	subu $t3, $t3, 1   # decrement by 1
	beq  $t3, $zero, myself
	addu $t0, $t0, 4
	addu $t1, $t1, 4
	addu $t2, $t2, 4
	j    myloop

myself:
	j    myself

.data
.align 4
op1:    .word  1, 2, 3, 4
op2:    .word  5, 6, 7, 8
result: .word  0, 0, 0, 0

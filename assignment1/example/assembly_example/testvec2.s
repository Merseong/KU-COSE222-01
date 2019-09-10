.text
.align 4

main:

	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	addi $a0, $0, 2
	sw   $a1, f
	addi $a1, $0, 3
	jal  sum
	sw   $v0, y
	lw   $ra, 0($sp)
	addi  $sp, $sp, 4
	jr   $ra

sum:
	add  $v0, $a0, $a1
	jr   $ra

.data
.align 4
f: .word  1, 2, 3, 4 
g: .word  5, 6, 7, 8
y: .word  9, 0, 0, 0 

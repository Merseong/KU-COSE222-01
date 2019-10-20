.text
.align 4

main:
	la   $t0, Input_data   # get Input_data address
	la   $t1, Output_data   # get Output_data address
	subu $t2, $t1, $t0   # get address diff of Input and Output
	sra  $t2, $t2, 2   # get count of words (n)
	ori  $t3, $t1, 0   # copy address of Output_data
	ori  $t4, $t2, 0   # copy count of words

copy:
	lw   $s0, 0($t0)   # read input
	sw   $s0, 0($t3)   # and copy to output
	subu $t4, $t4, 1   # decrease number of count
	beq  $t4, $zero, sortReady   # if there are no more word to copy, go to sort
	addu $t0, $t0, 4   # goto next input address
	addu $t3, $t3, 4   # goto next output address
	j    copy   # repeat copy

sortReady:	
	ori  $t3, $zero, 0   # t3: i -> 0 ~ 31
	ori  $t4, $zero, 0   # t4: j -> 0 ~ (30 - i) * 4
	subu $t8, $t2, 1   # get (n - 1)
	sub  $t8, $t8, $t3   # get (n - 1 - i)
	sll  $t8, $t8, 2   # t4 end point (n - i - 1) * 4

sort:
    bge  $t4, $t8, sortNext   # if (j >= (n - i - 1) * 4) end j cycle
	add  $t5, $t1, $t4   # get address of Output_data[t4]
	lw   $s0, 0($t5)   # get Output_data[t4]
	addi $t6, $t5, 4   # get address of Output_data[t4 + 1]
	lw   $s1, 0($t6)   # get Output_data[t4 + 1]
	blt  $s0, $s1, swap   # if (s0 is smaller than s1) swap [t4], [t4 + 1]
	addi $t4, $t4, 4    # goto next word (j++)
	j    sort   # repeat sort

sortNext:
	addi $t3, $t3, 1   # i++
	ori  $t4, $zero, 0   # reset j to 0
	blt  $t3, $t2, sort   # if (i is smaller than n) start next j cycle
	j    end   # end bubble sorting

swap:
	sw   $s1, 0($t5)   # write value of t5 to t6
	sw   $s0, 0($t6)   # write previous value of t6 to t5 
	addi $t4, $t4, 4    # goto next word (j++)
	j    sort   # go back to sort

end:
	j    end   # end of sorting program

.data
.align 4
Input_data:	.word 2, 0, -7, -1, 3, 8, -4, 10
	.word -9, -16, 15, 13, 1, 4, -3, 14
	.word -8, -10, -15, 6, -13, -5, 9, 12
	.word -11, -14, -6, 11, 5, 7, -2, -12
Output_data:	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0

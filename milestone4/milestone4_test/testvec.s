.text
.align 4
main:

addi $3, $0, 0x800
nop
add $8, $3, $3
nop
add $8, $8, $8
nop
add $8, $8, $8
nop
add $8, $8, $8
nop
add $8, $8, $8
nop

forever:
	j forever

.data
.align 4

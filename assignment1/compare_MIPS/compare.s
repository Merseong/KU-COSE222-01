	.file	1 "compare.c"
	.section .mdebug.abi32
	.previous
	.text
	.align	2
	.globl	compare
	.ent	compare
compare:
	.frame	$fp,24,$31		# vars= 16, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	lw	$2,24($fp)
	nop
	sw	$2,12($fp)
	lw	$3,28($fp)
	nop
	sw	$3,8($fp)
	lw	$4,8($fp)
	lw	$3,12($fp)
	nop
	slt	$2,$3,$4
	beq	$2,$0,$L2
	nop

	lw	$4,12($fp)
	nop
	sw	$4,8($fp)
$L2:
	lw	$2,8($fp)
	nop
	sw	$2,0($fp)
	lw	$2,0($fp)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	compare
	.size	compare, .-compare
	.ident	"GCC: (GNU) 4.1.1"

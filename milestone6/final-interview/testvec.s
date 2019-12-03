.text
.align 4

	la  $sp, stack    # load address
	j	Count


.data
.align 4
stack:
	.space 1024

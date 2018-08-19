	.text
main:
	la	$a0,n1
	la	$a1,n2
	jal	swap
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swap:	# your code goes here
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	
	lw $t0, 0($sp)	# create t0
	
	lw $t1, 0($a0)	# load a0 in t1
	sw $t1, 0($t0)	# save t1 in t0
	
	lw $t1, 0($a1)	# load a1 in t1
	sw $t1, 0($a0)	# save t1 in a0
	
	lw $t1, 0($t0)	# load t0 in t1
	sw $t1, 0($a1)	# save t1 in a1
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
	
	

	.data
n1:	.word	14
n2:	.word	27

main:
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:	# your code goes here
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  first1posv1
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
	
first1posv1:
	beq  $a0, $zero, return2
	addi $t0, $zero, 31
	
loop:
	slti $t1, $a0, 0
	bne  $t1, $zero, return1
	sll  $a0, $a0, 1
	addi $t0, $t0, -1
	j    loop
	
return1:
	add  $v0, $t0, $zero
	jr   $ra
	
return2:
	addi $v0, $zero, -1
	jr   $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra

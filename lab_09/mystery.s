
	.text

main:
	li $a0, 0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 196
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -452
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 2
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li $a0, 3
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li 	$v0, 10		# terminate program
	syscall

putDec: 
	## FILL IN ##
	move $t0, $a0
	slt  $t1, $a0, $zero			#checks to see if the 2's complement number is negative
	beq  $t1, $zero, loop_putDec	#if positive, prints out character, else converts it to positive
	li   $a0, '-'
	li   $v0, 11
	syscall
	not  $t0, $t0
	addi $t0, $t0, 1				#stores the converted number
	add  $t2, $zero, $zero			#i = 0
loop_putDec:
	addi $sp, $sp, -4
	rem  $t3, $t0, 10
	sb   $t3, 0($sp)
	div  $t0, $t0, 10
	addi $t2, $t2, 1
	bne  $t3, $zero, loop_putDec
	li   $t3, 1
	beq  $t2, $t3, print_putDec
	addi $t2, $t2, -1
print_putDec:
	addi $sp, $sp, 4
	beq  $t2, $zero, return_putDec
	li   $a0, '0'
	lb   $t3, 0($sp)
	add  $a0, $a0, $t3
	li   $v0, 11
	syscall
	addi $t2, $t2, -1
	j print_putDec
return_putDec:
	move $a0, $t0
	jr	$ra		# returnv

# mystery: bne $0, $a0, recur	# 
	# li $v0, 0				#
	# jr $ra					#
 # recur: sub $sp, $sp, 8		#
	# sw $ra, 4($sp)			#
	# sub $a0, $a0, 1			#
	# jal mystery				#
	# sw $v0, 0($sp)			#
	# jal mystery				#
	# lw $t0, 0($sp)			#
	# addu $v0, $v0, $t0		#
	# addu $v0, $v0, 1		#
	# add $a0, $a0, 1			#
	# lw $ra, 4($sp)			#
	# add $sp, $sp, 8			#
	# jr $ra					#

mystery: bne $0, $a0, recur	# 
	li $v0, 0				#
	jr $ra					#
 recur: sub $sp, $sp, 8		#
	sw $ra, 4($sp)			#
	sub $a0, $a0, 1			#
	jal mystery				#
	move $t0, $v0
	sw $t0, 0($sp)			#
	jal mystery				#
	move $t0, $v0
	lw $t1, 0($sp)			#
	addu $t0, $t0, $t1		#
	addu $t0, $t0, 1		#
	add $a0, $a0, 1			#
	lw $ra, 4($sp)			#
	add $sp, $sp, 8			#
	move $v0, $t0
	jr $ra					#

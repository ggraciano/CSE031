.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of original list: "
str3: .asciiz "Enter a key to search for: "
str4: .asciiz "Content of sorted list: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"



.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	#read size of list from user
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	#read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	move $a0, $s1
	move $a1, $s0
	
	jal inSort	#Call inSort to perform insertion sort in original list
	
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall 
	la $a0, original_list
	move $a1, $s0
	jal printList	#Print original list
	li $v0, 4 
	la $a0, str4 
	syscall 
	lw $a0, 4($sp)
	jal printList	#Print sorted list
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5	#read search key from user
	syscall
	move $a3, $v0
	lw $a0, 4($sp)
	jal bSearch	#call bSearch to perform binary search
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	#Your implementation of printList here
#void print_list(long list[], long start, long end) {
#	for (long i = start; i < end - 1; i++) {
#		cout << list[i] << endl;
#	}
#	return;
#}

#a1 - size of list
#a0 - address of list

	addi $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $a1, 4($sp)
	sw   $a0, 8($sp)
	
	add  $t0, $zero, $zero
ploop_1:
	sll  $t1, $t0, 2
	lw   $a0, 8($sp)
	add  $t2, $t1, $a0
	li   $v0, 1
	lw   $a0, 0($t2)
	syscall
	li   $v0, 11
	li   $a0, 32	#SPACE
	syscall
	addi $t0, $t0, 1
	bne  $t0, $a1, ploop_1
	li   $v0, 11
	li   $a0, 10	#LF
	syscall
	
	lw   $a0, 8($sp)
	lw   $a1, 4($sp)
	lw   $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	#Your implementation of inSort here
#void insertion_sort(long list[], long start, long end) {
#	for (long i = start + 1; i < end + 1; i++) {
#		long j = i;
#		while (j > 0 && list[j - 1] > list[j]) {
#			long temp = list[j];
#			list[j] = list[j - 1];
#			list[j - 1] = temp;
#			j--;
#		}
#	}
#	return;
#}

#$a1 - size of list
#$a0 - address of list

	addi $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $a1, 4($sp)
	sw   $a0, 8($sp)
	
	la   $v0, sorted_list
	add  $a2, $zero, $zero	#start = 0
	add  $t0, $zero, $zero
iloop_0:
	sll  $t1, $t0, 2
	add  $t2, $t1, $zero
	add  $t1, $t1, $a0
	add  $t2, $t2, $v0
	lw   $t3, 0($t1)
	sw   $t3, 0($t2)
	addi $t0, $t0, 1
	bne  $t0, $a1, iloop_0
if_inSort:
	addi $t0, $zero, 1		#i = 1
	bne  $t0, $a1, else_inSort
	j return_inSort
else_inSort:
	add  $t1, $zero, $zero	#j = 0
iloop_1:
	add  $t1, $t0, $zero	#j = i
iloop_2:
	addi $t2, $t1, -1
	sll  $t3, $t1, 2
	add  $t3, $t3, $v0
	lw   $t4, 0($t3)		#temp1 = list[j]
	sll  $t5, $t2, 2
	add  $t5, $t5, $v0
	lw   $t6, 0($t5)		#temp2 = list[j-1]
	bge  $t4, $t6, end_iloop_2
	sw   $t6, 0($t3)        #list[j] = list[j-1]
	sw   $t4, 0($t5)		#list[j-1] = list[j]
	addi $t1, $t1, -1
	slti $t3, $t1, 0
	bne  $t3, $zero, end_iloop_2
	slt  $t3, $t4, $t6
	addi $t4, $zero, 1
	beq  $t3, $t4, iloop_2
end_iloop_2:
	addi $t0, $t0, 1
	bne  $t0, $a1, iloop_1
return_inSort:
	lw   $a0, 8($sp)
	lw   $a1, 4($sp)
	lw   $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	#Your implementation of bSearch here
#bool binary_search(long* list, long start, long end, long value) {
#	long mid = start + (end - start) / 2;
#	if (end >= start) {
#		if (list[mid] == value) {
#			return true;
#		}
#		else if (list[mid] > value) {
#			binary_search(list, 0, mid - 1, value);
#		}
#		else if (list[mid] < value) {
#			binary_search(list, mid + 1, end, value);
#		}
#		else {
#			return false;
#		}
#	}
#}

#a1 - size of list
#a0 - address of list
#a2 - start of list
#a3 - key

	addi $sp, $sp, -20
	sw   $ra, 0($sp)
	sw   $a1, 4($sp)
	sw   $a0, 8($sp)
	sw   $a2, 12($sp)
	sw   $a3, 16($sp)
	
	add  $a1, $a1, $zero
	srl  $a1, $a1, 1		#mid = size / 2
	sll  $t0, $a1, 2
	add  $t0, $t0, $a0
	lw   $t1, 0($t0)		#temp1 = list[mid]
	slt  $t2, $a1, $a2
	bne  $t2, $zero, else_bSearch	#(end >= start) = false
	beq  $t1, $a3, if_bSearch
	slt  $t3, $a3, $t1
	bne  $t3, $zero, else_if_bSearch_1
	beq  $t3, $zero, else_if_bSearch_2
if_bSearch:
	li   $v0, 1
	j return_bSearch
else_if_bSearch_1:
	addi $a1, $a1, -1		#end = mid - 1
	jal bSearch
	j return_bSearch
else_if_bSearch_2:
	addi $a2, $a1, 1		#start = mid + 1
	jal bSearch
	j return_bSearch
else_bSearch:
	li   $v0, 0
return_bSearch:
	lw   $ra, 0($sp)
	lw   $a1, 4($sp)
	lw   $a0, 8($sp)
	lw   $a2, 12($sp)
	lw   $a3, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	

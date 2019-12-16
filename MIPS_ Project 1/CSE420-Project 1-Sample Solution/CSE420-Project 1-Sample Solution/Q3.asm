.data
array:		.word   0 : 10  # array of 10 words
sum:		.word	0
printString:	.asciiz	"Sum = "
	
.text
	.globl main
main:
	la   $s0, array 	# load the address of the first element of the array
	la   $s1, sum 		# load the address of the sum (pointer to the sum)
	sw   $0, 0($s1)		# Initialize the value of sum to 0

	move $t0, $0
loop1:				# Stores the values for elements 0-9
	beq  $t0, 10, next	# Branches to the next loop once counter reaches 10
	### the folowing instructions compute 3(i+1)
	addi $t0, $t0, 1	# Increment variable i
	sll  $t1, $t0, 1	# t1 = t0 * 2 = 2(i+1)
	add  $t1, $t1, $t0	# t1 = 3(i+1)
	sw   $t1, ($s0)		# Store 3(i+1) into array[i]	
	
	addi $s0, $s0, 4	#Increment to the next index of the array
	j loop1
	
next:
	la   $s0, array 	# load the address of the first element of the array
	move $s2, $0
loop2:				# This loop calls the updateSum function 10 times
	beq  $s2, 10, exit
	add  $a0, $zero, $s1 	# Store the pointer to the sum as first argument
	move $a1, $s0 		# Store the address of the indexed array element as second argument
	jal  updateSum
	
	addi $s2, $s2, 1 	# Increment loop iterator i by 1
	addi $s0, $s0, 4 	# Increment the address to access next element of the array
	j    loop2

exit:
	la   $a0, printString	# Prints the string "sum = " on the console
	li   $v0, 4
	syscall

	lw   $a0, 0($s1)	# Prints the value of the summation computed
	li   $v0, 1
	syscall

	li   $v0, 10		# Terminate
	syscall			

updateSum:
	lw   $t0, 0($a0) 	# Load the stored value of the sum
	lw   $t1, 0($a1) 	# Load the value of the indexed array element
	add  $t0, $t0, $t1	# Update the running summation
	sw   $t0, 0($a0) 	# Store the new value back to the variable pointed
	jr   $ra		# Return to caller

.data
	string1: .asciiz "Please enter an integer value for variable i: "
	string2: .asciiz "Please enter an integer value for variable x: "
	string3: .asciiz "compute(i,x) is: "

.text
	.globl main
main:
	la $a0, string1		# Prompt the user for variable i
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	add $s0, $zero, $v0 	# $s0 has the value of i

	la $a0, string2		# Prompt the user for variable x
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	add $s1, $zero, $v0 	# $s1 has the value of x

	add $a0, $zero, $s0 	# Argument 1 is i
	add $a1, $zero, $s1 	# Argument 2 is x
	jal compute
	add $s0, $zero, $v0	# Save the value returned by compute(i,x)

	la $a0, string3		# Display string3 to the user
	li $v0, 4
	syscall

	add $a0, $zero, $s0		
	li $v0, 1		# Print the value returned by compute
	syscall

	li $v0, 10		# Terminate
	syscall


compute:
	add $sp, $sp, -12 	# Allocate space on the stack for the arguments and return address
	sw  $ra, 0($sp)		# Save the return address on the stack
	sw  $a0, 4($sp)		# Save the value of i on the stack
	sw  $a1, 8($sp)		# Save the value of x on the stack
	bgt $a1, $0, return1	# If x is greater than zero, branch to return1
	bgt $a0, $0, return2	# Else, if i is greater than zero, branch to return2
	j return3		# Else go to return3

return1:
	subi $a1, $a1, 1	# Decrement x by 1
	jal compute 		# Call compute again i.e. compute(i,x-1)
	addi $v0, $v0, 1        # Add 1 to the returned value compute(i,x-1)
	j exit			# Load back values from stack and return

return2:
	subi $a0, $a0, 1	# Decrement i by 1
	move $a1, $a0		# $a1 = $a0 = i - 1
	jal compute 		# Call compute again i.e. compute(i-1,i-1)
	addi $v0, $v0, 5        # Add 5 to the returned value compute(i-1,i-1)
	j exit			# Load back values from stack and return


return3:
	addi $v0, $0, 1		#Return 1	
	
exit:
	lw $ra, 0($sp) 		# Load back values from the stack
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
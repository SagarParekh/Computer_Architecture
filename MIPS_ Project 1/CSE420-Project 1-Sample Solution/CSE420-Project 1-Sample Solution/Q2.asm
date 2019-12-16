# Program to compute 10u^2  +  4uv + v^2 - 1

.data
    string1: .asciiz "Please enter the value of u: "
    string2: .asciiz "Please enter the value of v: "
    string3: .asciiz "The output of the function is: "

.text

main: 
	# STEP 1 -- get the first operand
        la   $a0, string1	# Load address of the string
        li   $v0, 4        	# For diplaying a string to console, set $v0 to 4
        syscall         	# Display the string

        li   $v0, 5
        syscall            	# Getting the value of u from the user
        move $a1, $v0    	# Storing the value of u for later use
        move $t0, $v0		# Make a copy for later use
        
        # STEP 2 -- get the second operand
        la   $a0, string2
        li   $v0, 4
        syscall

        li   $v0, 5
        syscall            
        move $t1, $v0    	# Storing the value v for later use
    
        # STEP 3 -- Load arguments and compute 10*(u^2) in $s0
   	move $a0, $a1		# Move value of u to argument $a0		
  	jal  Square		# function call
  	addi $a0, $0, 3		# a0 = 3
  	move $a1, $v0
  	jal  Multiply
	add  $s0, $v0, $zero	# $s0 = 3*(u^2)
	
	# STEP 4 -- Compute 4*u*v
	move $a0, $t0		# $a0 = u
	addi $a1, $t1, 0	# $a1 = v
  	jal  Multiply		# function call
  	addi $a0, $0, 7
  	move $a1, $v0
  	jal  Multiply
  	add  $s0, $s0, $v0	# Update the sum $s0 = $s0 + 7*u*v
  	
  	# STEP 5 -- Compute v*v - 1
	add  $a0, $t1, $0	# $a0 = v
	move $a1, $t1		# $a1 = v
      	jal  Square		# Function call
	sub  $s0, $s0, $v0	# $s0 = $s0 - v0
	add  $s0,$s0, 1         # $s0 = $s0 + 1
   
   	# STEP 6 -- Print the output
   	la   $a0, string3	# Load address of the string
        li   $v0, 4        	# For diplaying a string to console, set $v0 to 4
        syscall         	# Display the string

        li  $v0, 1        	# For printing the value of int, set $v0 to 1
        move $a0, $s0
        syscall         	# Printing the value of the result
    
        li $v0, 10        	# Command for exiting the program
        syscall			# Terminate
    

#################################
Square: 
	mult $a0, $a0	# A * A
	mflo $v0	# return X*X
	jr $ra	
	
#################################
Multiply: 
	mult $a0, $a1	# A * B
	mflo $v0	# return A * B
	jr $ra	
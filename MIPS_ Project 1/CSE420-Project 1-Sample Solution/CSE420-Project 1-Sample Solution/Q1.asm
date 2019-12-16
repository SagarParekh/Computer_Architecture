
################# Data Segment #####################
.data
string: .asciiz "WELCOME TO COMPUTER ARCHITECTURE CLASS!"

################# Code Segment #####################
.text
	.globl main
main:
	# Loop through the string
	# Convert only if character is A-Z
	move $t0, $0		# Counter to access byte element
loop:
	lb   $t1, string($t0)	# Access byte value infexed by t0 	
	beq  $t1, 0, exit	# Exit if loaded ASCII value is NULL
	blt  $t1, 65, skip	# Skip if not in range of A-Z 
	bgt  $t1, 90, skip
	addi $t1, $t1, 32	# Otherwise, convert to lowcase by adding 0x20
	sb   $t1, string($t0)	# Store back the updated character
skip:
	addi $t0, $t0, 1	# Increment byte index counter
	j loop

exit:
    	# Print the upper-case string
    	li, $v0, 4		# Syscall number 4 will print string whose address is in $a0
    	la  $a0, string		# Load address of the string
    	syscall    		# Print the string

    	# Done. Exit program
    	li $v0, 10    		# Syscall number 10 is to terminate the program
    	syscall			# Terminate